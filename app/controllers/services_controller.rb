class ServicesController < ApplicationController

  def authorize
    redirect_to root_path
    case params[:oauth]
      when 'oauth1'
        connection = current_user.connections.find(params[:id])
        if params[:not_approved]
          connection.update_attribute :state, 'error'
        else
          Oauth1AuthWorker.perform_async connection.id
        end
      when 'oauth2'
        id = params[:state].to_i
        connection = current_user.connections.find(id)
        if params[:code].nil?
          connection.update_attribute :state, 'error'
        else
          Oauth2AuthWorker.perform_async id, params[:code]
        end
      else
        render file: 'public/404.html', layout: false
    end
  rescue ActiveRecord::RecordNotFound
    render file: 'public/500.html', layout: false
  end

  # Creates initial session and redirects user to authorize use
  def new
    if current_user.connections.count > 5
      render file: 'public/500.html', layout: false
    else
        connection = current_user.connections.find(params[:id]) if params[:id]
        case params[:service]
          when 'dropbox'
            connection = current_user.dropbox_connections.create(state: 'in_progress') unless params[:id]
            @client = Signet::OAuth1::Client.new(
                client_credential_key: ENV['DROPBOX_APP_KEY'],
                client_credential_secret: ENV['DROPBOX_APP_SECRET'],
                temporary_credential_uri: 'https://api.dropbox.com/1/oauth/request_token',
                authorization_uri: 'https://api.dropbox.com/1/oauth/authorize',
                token_credential_uri: 'https://api.dropbox.com/1/oauth/access_token'
            )
            @client.fetch_request_token!
            @client.callback = url_for(controller: :services, action: :authorize, service: 'dropbox', only_path: false,
                                      id: connection.id, oauth: 'oauth1')
          when 'google'
            connection = current_user.google_connections.create(state: 'in_progress') unless params[:id]
            @client = Signet::OAuth2::Client.new(
                token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                client_id: ENV['GOOGLE_CLIENT_ID'],
                client_secret: ENV['GOOGLE_CLIENT_SECRET'],
                scope: 'https://www.googleapis.com/auth/drive',
                state: connection.id.to_s,
                redirect_uri: url_for(controller: :services, action: :authorize, only_path: false, oauth: 'oauth2')
            )
          else
            render file: 'public/404.html', layout: false
            return
        end
      connection.update_attributes(session: @client, state: 'in_progress')
        redirect_to @client.authorization_uri.to_s
    end

    #render error page if user tries to use connection that doesn't belong to them
    rescue ActiveRecord::RecordNotFound
      render file: 'public/500.html', layout: false
  end
end
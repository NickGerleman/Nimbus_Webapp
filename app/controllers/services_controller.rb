class ServicesController < ApplicationController

  def confirm
    redirect_to root_path
    case params[:service]
      when 'dropbox'
        connection = current_user.dropbox_connections.find(params[:id])
        if params[:not_approved]
          connection.update_attribute :state, 'error'
        else
          ConfirmDropboxSessionWorker.perform_async connection.id
        end
      when 'google'
        connection = current_user.google_connections.find(params[:id])
        if params[:code].nil?
          connection.update_attribute :state, 'error'
        else
          ConfirmGoogleSessionWorker.perform_async connection.id, params[:code]
        end
      else
        render file: 'public/404.html', layout: false
    end
  end

  # Creates initial session and redirects user to authorize use
  #
  def new
    if current_user.connections.count > 5
      render file: 'public/500.html', layout: false
    else
      begin
        case params[:service]
          when 'dropbox'
            client = Signet::OAuth1::Client.new(
                client_credential_key: ENV['DROPBOX_APP_KEY'],
                client_credential_secret: ENV['DROPBOX_APP_SECRET'],
                temporary_credential_uri: 'https://api.dropbox.com/1/oauth/request_token',
                authorization_uri: 'https://api.dropbox.com/1/oauth/authorize',
                token_credential_uri: 'https://api.dropbox.com/1/oauth/access_token'
            )
            client.fetch_request_token!
            if params[:id]
              connection = current_user.dropbox_connections.find(params[:id])
              connection.update_attributes(session: client, state: 'in_progress')
            else
              connection = current_user.dropbox_connections.create(session: client, state: 'in_progress')
            end
            client.callback = url_for(controller: :services, action: :confirm, service: 'dropbox', only_path: false,
                                      id: connection.id)
          when 'google'
            client = Signet::OAuth2::Client.new(
                token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                client_id: ENV['GOOGLE_CLIENT_ID'],
                client_secret: ENV['GOOGLE_CLIENT_SECRET'],
                scope: 'https://www.googleapis.com/auth/drive'
            )
            if params[:id]
              connection = current_user.google_connections.find(params[:id])
              connection.update_attributes(session: client, state: 'in_progress')
            else
              connection = current_user.google_connections.create(session: client, state: 'in_progress')
            end
            client.redirect_uri = url_for(controller: :services, action: :confirm, service: 'google',
                                          only_path: false, id: connection.id)
          else
            render file: 'public/404.html', layout: false
        end
        redirect_to client.authorization_uri.to_s
          #render error page if user tries to use connection that doesn't belong to them
      rescue ActiveRecord::RecordNotFound
        render file: 'public/500.html', layout: false
      end
    end
  end
end
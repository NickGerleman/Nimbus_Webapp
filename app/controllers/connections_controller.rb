class ConnectionsController < ApplicationController
  force_ssl(only: :authorize) if Rails.env.production?

  #Get Ttoken after OAuth Callback
  def authorize
    case params[:oauth]
      #Oauth1 code removed
      when 'oauth2'
        #OAuth State is used to store user ID
        id = params[:state].to_i
        connection = current_user.connections.find(id)
        if params[:code].nil?
          connection.update_attribute :state, 'error'
        else
          Oauth2AuthWorker.perform_async id, params[:code]
        end
      else
        render status: :bad_request, text: 'Invalid OAuth Version'
        return
    end
    redirect_to root_path
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, text: 'User Connection Not FOund'
  end

  #Delete the Connection
  def destroy
    connection = current_user.connections.find(params[:id])
    connection.destroy
    redirect_to root_path
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, text: 'User Connection Not Found'
  end

  # Creates initial session and redirects user to authorize use
  def new
    if current_user.has_max_connections
      render status: :forbidden, text: 'Connection Limit Reached'
    else
        connection = current_user.connections.find(params[:id]) if params[:id]
        case params[:service]
          when 'dropbox'
            unless params[:id]
              connections = current_user.dropbox_connections
              name = "Connection #{connections.count + 1}"
              connection = connections.create(state: 'in_progress', name: name)
            end
            @client = Signet::OAuth2::Client.new(
                client_id: ENV['DROPBOX_CLIENT_ID'],
                client_secret: ENV['DROPBOX_CLIENT_SECRET'],
                authorization_uri: 'https://www.dropbox.com/1/oauth2/authorize',
                token_credential_uri: 'https://api.dropbox.com/1/oauth2/token',
                state: connection.id.to_s,
                redirect_uri: url_for(controller: :connections, action: :authorize, only_path: false, oauth: 'oauth2')
            )
            #Workaround for Dropbox refusing code if access_type or approval_prompt is present
            connection.update_attributes(session: @client, state: 'in_progress')
            redirect_to @client.authorization_uri.to_s.gsub('access_type=offline&approval_prompt=force&', '')
            return
          when 'google'
            unless params[:id]
              connections = current_user.google_connections
              name = "Connection #{connections.count + 1}"
              connection = connections.create(state: 'in_progress', name: name)
            end
            @client = Signet::OAuth2::Client.new(
                token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
                authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
                client_id: ENV['GOOGLE_CLIENT_ID'],
                client_secret: ENV['GOOGLE_CLIENT_SECRET'],
                scope: 'https://www.googleapis.com/auth/drive',
                state: connection.id.to_s,
                redirect_uri: url_for(controller: :connections, action: :authorize, only_path: false, oauth: 'oauth2')
            )
          when 'box'
            unless params[:id]
              connections = current_user.box_connections
              name = "Connection #{connections.count + 1}"
              connection = connections.create(state: 'in_progress', name: name)
            end
            @client = Signet::OAuth2::Client.new(
                token_credential_uri: 'https://www.box.com/api/oauth2/token',
                authorization_uri: 'https://www.box.com/api/oauth2/authorize',
                client_id: ENV['BOX_CLIENT_ID'],
                client_secret: ENV['BOX_CLIENT_SECRET'],
                response_type: 'code',
                state: connection.id.to_s,
                redirect_uri: url_for(controller: :connections, action: :authorize, only_path: false, oauth: 'oauth2')
            )
          when 'skydrive'
            unless params[:id]
              connections = current_user.skydrive_connections
              name = "Connection #{connections.count + 1}"
              connection = connections.create(state: 'in_progress', name: name)
            end
            @client = Signet::OAuth2::Client.new(
                token_credential_uri: 'https://login.live.com/oauth20_token.srf',
                authorization_uri: 'https://login.live.com/oauth20_authorize.srf',
                client_id: ENV['SKYDRIVE_CLIENT_ID'],
                client_secret: ENV['SKYDRIVE_CLIENT_SECRET'],
                response_type: 'code',
                scope: 'wl.offline_access',
                state: connection.id.to_s,
                redirect_uri: url_for(controller: :connections, action: :authorize, only_path: false, oauth: 'oauth2')
            )
          else
            raise status: :bad_request, text: 'Invalid Service'
        end
        connection.update_attributes(session: @client, state: 'in_progress')
        redirect_to @client.authorization_uri.to_s
    end

    rescue ActiveRecord::RecordNotFound
      render status: :not_found, text: 'User Connection Not Found'
  end

  def show
    render status: :not_found, text: 'User Not Logged In' unless current_user
    connection = current_user.connections.find(params[:id])
    render json: connection, serializer: ConnectionSerializer
    rescue ActiveRecord::RecordNotFound
      render status: :not_found, text: 'User Connection Not Found'
  end

  def index
    render status: :not_found, text: 'User Not Logged In' unless current_user
    connections = current_user.connections.where(state: 'success')
    render json: connections, each_serializer: ConnectionSerializer, root: false
  end

end

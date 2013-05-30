require 'google/api_client'
require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController

  # Gets and stores access tokens after the user has allowed access
  #
  # @option params [String] :id the service to use
  def confirm
    redirect_to root_path
    if params[:id]== 'dropbox'
      ConfirmDropboxSessionWorker.perform_async current_user.id
    end
  end

  # Creates initial session and redirects user to authorize use
  #
  # @option params [String] :id the service to use
  def new
    case params[:id]
      when 'dropbox'
        current_user.dropbox_connection.destroy unless current_user.dropbox_connection.nil?
        session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
        session.get_request_token
        redirect_to session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'dropbox',
                                                      only_path: false)
        current_user.create_dropbox_connection session: session.serialize, state: 'in_progress'
      when 'google'
        client = Google::APIClient.new
        client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
        client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
        client.authorization.redirect_uri = url_for(controller: :services, action: :confirm, id: 'google',
                                                    only_path: false)
        client.authorization.scope = 'https://www.googleapis.com/auth/drive'
        uri = client.authorization.authorization_uri
        redirect_to uri.to_s
      else
        raise 'Invalid Service'
    end

  end
end
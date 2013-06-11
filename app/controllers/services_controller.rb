require 'signet/oauth_1/client'
require 'signet/oauth_2/client'

class ServicesController < ApplicationController

  def confirm
    redirect_to root_path
    case params[:id]
      when 'dropbox'
        if params[:not_approved]
          current_user.dropbox_connection.update_attribute :state, 'error'
        else
          ConfirmDropboxSessionWorker.perform_async current_user.id
        end
      when 'google'
        if params[:code].nil?
          current_user.google_connection.update_attribute :state, 'error'
        else
          ConfirmGoogleSessionWorker.perform_async current_user.id, params[:code]
        end
      else
        raise 'Invalid Service'
    end
  end

  # Creates initial session and redirects user to authorize use
  #
  # @option params [String] :id the service to use
  def new
    case params[:id]
      when 'dropbox'
        current_user.dropbox_connection.destroy unless current_user.dropbox_connection.nil?
        client = Signet::OAuth1::Client.new(
            client_credential_key: ENV['DROPBOX_APP_KEY'],
            client_credential_secret: ENV['DROPBOX_APP_SECRET'],
            temporary_credential_uri: 'https://api.dropbox.com/1/oauth/request_token',
            authorization_uri: 'https://api.dropbox.com/1/oauth/authorize',
            token_credential_uri: 'https://api.dropbox.com/1/oauth/access_token',
            callback: url_for(controller: :services, action: :confirm, id: 'dropbox', only_path: false)
        )
        client.fetch_request_token!
        current_user.create_dropbox_connection(session: client, state: 'in_progress')
      when 'google'
        current_user.google_connection.destroy unless current_user.google_connection.nil?
        client = Signet::OAuth2::Client.new(
            token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
            authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
            client_id: ENV['GOOGLE_CLIENT_ID'],
            client_secret: ENV['GOOGLE_CLIENT_SECRET'],
            scope: 'https://www.googleapis.com/auth/drive',
            redirect_uri: url_for(controller: :services, action: :confirm, id: 'google', only_path: false)
        )
        current_user.create_google_connection(session: client, state: 'in_progress')
      else
        raise 'Invalid Service'
    end
    redirect_to client.authorization_uri.to_s
  end
end
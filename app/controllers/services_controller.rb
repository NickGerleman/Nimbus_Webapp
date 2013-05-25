require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController

  # Gets and stores access tokens after the user has allowed access
  #
  # @param [Hash] params Parameters Given
  # @option params [String] :id the service to use
  def confirm
    #TODO: move to background task
    if params[:id]== 'Dropbox'
      serialized_session = current_user.dropbox_connection.session
      session = DropboxSession.deserialize serialized_session
      token = session.get_access_token
      if token.nil?
        current_user.dropbox_connection.update_attribute :completed, false
      end
      serialized_session = session.serialize
      current_user.dropbox_connection.update_attribute :session, serialized_session
      current_user.dropbox_connection.update_attribute :completed, true
    end
  end

  # Creates initial session and redirects user to authorize use
  #
  # @param [Hash] params Parameters Given
  # @option params [String] :id the service to use
  def new
    if params[:id] == 'Dropbox'
      session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
      session.get_request_token
      redirect_to session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'Dropbox',
                                                    only_path: false, host: 'nimbus-web.herokuapp.com', protocol: 'https')
      current_user.create_dropbox_connection session: session.serialize
    end
  end
end
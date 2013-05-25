require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController
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

  def new
    if params[:id] == 'Dropbox'
      if current_user.dropbox_connection.nil? or !current_user.dropbox_connection.completed
        session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
      else
        session = DropboxSession.deserialize current_user.dropbox_connection.session
      end
      session.get_request_token
      redirect_to session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'Dropbox',
                                                    only_path: false, host: 'nimbus-web.herokuapp.com', protocol: 'https')
      current_user.create_dropbox_connection session: session.serialize
    end
  end
end
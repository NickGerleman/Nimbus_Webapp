require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController
  def confirm
    serialized_session = current_user.dropbox_connection.session
    session = DropboxSession.deserialize serialized_session
    @token = session.get_access_token
    serialized_session = session.serialize
    current_user.dropbox_connection.update_attribute :session, serialized_session
  end

  def new
    if current_user.dropbox_connection.nil?
      session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
    else
      session = current_user.dropbox_connection.session
    end
    session.get_request_token
    @dropbox = session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'Dropbox',
                                                 only_path: false, host: 'nimbus-web.herokuapp.com', protocol: 'https')
    current_user.create_dropbox_connection session: session.serialize
  end
end
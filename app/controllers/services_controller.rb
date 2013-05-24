require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController
  def confirm
    serialized_session = current_user.dropbox_connections.last.session
    session = DropboxSession.deserialize serialized_session
    @token = session.get_access_token
    serialized_session = session.serialize
    current_user.dropbox_connections.last.update_attribute :session, serialized_session
  end

  def new
    session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
    session.get_request_token
    @dropbox = session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'Dropbox',
                                                 only_path: false, host: 'nimbus-web.herokuapp.com', protocol: 'https')
    current_user.dropbox_connections.create session: session.serialize
  end
end
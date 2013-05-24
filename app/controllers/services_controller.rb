require 'dropbox_sdk'
ACCESS_TYPE = :dropbox

class ServicesController < ApplicationController
  def confirm
    @token = @session.get_access_token
  end

  def new
    @session = DropboxSession.new ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET']
    @session.get_request_token
    @dropbox = @session.get_authorize_url url_for(controller: :services, action: :confirm, id: 'Dropbox',
                                                 only_path: false, host: 'nimbus-web.herokuapp.com', protocol: 'https')

  end
end
require 'dropbox_sdk'

class ConfirmDropboxSessionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.fin user_id
    serialized_session = user.dropbox_connection.session
    session = DropboxSession.deserialize serialized_session
    token = session.get_access_token
    if token.nil?
      user.dropbox_connection.update_attribute :completed, false
    end
    serialized_session = session.serialize
    user.dropbox_connection.update_attribute :session, serialized_session
    user.dropbox_connection.update_attribute :completed, true
  end
end
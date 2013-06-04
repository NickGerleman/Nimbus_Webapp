require 'dropbox_sdk'

class ConfirmDropboxSessionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    serialized_session = user.dropbox_connection.session
    session = DropboxSession.deserialize serialized_session
    serialized_session = session.serialize
    user.dropbox_connection.update_attribute :session, serialized_session
    user.dropbox_connection.update_attribute :state, 'success'
  end
end
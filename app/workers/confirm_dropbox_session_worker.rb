require 'dropbox_sdk'

class ConfirmDropboxSessionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find user_id
    serialized_session = user.dropbox_connection.session
    session = Marshal.load(serialized_session)
    token = session.get_access_token
    if token.nil?
      user.dropbox_connection.update_attribute :state, 'error'
    end
    serialized_session = Marshal.dump(session)
    user.dropbox_connection.update_attribute :session, serialized_session
    user.dropbox_connection.update_attribute :state, 'success'
  end
end
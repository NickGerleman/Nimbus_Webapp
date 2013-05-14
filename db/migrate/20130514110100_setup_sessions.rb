class SetupSessions < ActiveRecord::Migration
  def change
    remove_columns :users, :session_token, :session_expiration
  end
end

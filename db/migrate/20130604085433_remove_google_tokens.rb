class RemoveGoogleTokens < ActiveRecord::Migration
  def change
    remove_columns :google_connections, :access_key, :refresh_key
  end
end

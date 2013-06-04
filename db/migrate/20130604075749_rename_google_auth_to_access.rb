class RenameGoogleAuthToAccess < ActiveRecord::Migration
  def change
    rename_column :google_connections, :auth_key, :access_key
  end
end

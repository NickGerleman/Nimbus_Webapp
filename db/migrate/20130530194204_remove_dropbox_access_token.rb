class RemoveDropboxAccessToken < ActiveRecord::Migration
  def change
    remove_column :dropbox_connections, :access_token
  end
end

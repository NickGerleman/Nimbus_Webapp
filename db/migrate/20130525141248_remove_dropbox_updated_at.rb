class RemoveDropboxUpdatedAt < ActiveRecord::Migration
  def change
    remove_column :dropbox_connections, :updated_at
  end
end

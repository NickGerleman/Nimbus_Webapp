class ModifyDropbox < ActiveRecord::Migration
  def change
    remove_column :dropbox_connections, :completed
    add_column :dropbox_connections, :state, :string
    add_column :dropbox_connections, :access_token, :string
  end
end

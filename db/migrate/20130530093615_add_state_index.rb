class AddStateIndex < ActiveRecord::Migration
  def change
    add_index :dropbox_connections, :state
  end
end

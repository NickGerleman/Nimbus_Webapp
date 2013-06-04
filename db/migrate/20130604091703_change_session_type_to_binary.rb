class ChangeSessionTypeToBinary < ActiveRecord::Migration
  def change
    change_column :dropbox_connections, :session,:binary
    change_column :google_connections, :session,:binary
  end
end

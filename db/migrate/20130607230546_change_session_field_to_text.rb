class ChangeSessionFieldToText < ActiveRecord::Migration
  def change
    change_column :dropbox_connections, :session, :text
    change_column :google_connections, :session, :text
  end
end

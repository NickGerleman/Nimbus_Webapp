class CreateDropboxConnections < ActiveRecord::Migration
  def change
    create_table :dropbox_connections do |t|
      t.integer :user_id
      t.string :session

      t.timestamps
    end
  end
end

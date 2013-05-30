class CreateGoogleConnection < ActiveRecord::Migration
  def change
    create_table :google_connections do |t|
      t.string :auth_key
      t.string :refresh_key
      t.string :state
      t.timestamps
    end
    remove_column :google_connections, :updated_at
    add_index :google_connections, :state
  end
end

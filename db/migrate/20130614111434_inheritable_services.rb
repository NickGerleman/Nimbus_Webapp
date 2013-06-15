class InheritableServices < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.string :type
      t.string :state
      t.text :session
      t.integer :user_id
    end
    drop_table :dropbox_connections
    drop_table :google_connections
  end
end

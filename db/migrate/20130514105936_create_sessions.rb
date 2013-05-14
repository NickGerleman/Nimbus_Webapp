class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :token
      t.datetime :expiration
      t.integer :user_id
    end
    add_index :sessions, :token
    add_index :sessions, :expiration
  end
end

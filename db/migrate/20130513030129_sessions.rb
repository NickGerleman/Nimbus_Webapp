class Sessions < ActiveRecord::Migration
  def change
    remove_column :users, 'verified'
    add_column :users, :verified, :boolean
    add_column :users, :session_expiration, :datetime
    add_column :users, :session_token, :string
    add_column :users, :email_token, :string
    add_index :users, :session_expiration
    add_index :users, :session_token
    add_index :users, :email_token
  end
end
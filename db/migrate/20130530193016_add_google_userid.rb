class AddGoogleUserid < ActiveRecord::Migration
  def change
    add_column :google_connections, :user_id, :integer
  end
end

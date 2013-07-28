class AddConnectionExpireTime < ActiveRecord::Migration
  def change
    add_column :connections, :expires_at, :datetime, default: Time.now
    add_index :connections, :expires_at
  end
end

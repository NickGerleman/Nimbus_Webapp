class AddMoreIndices < ActiveRecord::Migration
  def change
    add_index :sessions, :user_id
    add_index :connections, :user_id
  end
end

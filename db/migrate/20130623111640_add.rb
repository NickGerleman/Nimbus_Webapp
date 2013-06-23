class Add < ActiveRecord::Migration
  def change
    add_column(:connections, :name, :string, {default: 'Unnamed Connection'})
  end
end

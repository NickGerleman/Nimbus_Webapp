class AddCompletedField < ActiveRecord::Migration
  def change
     add_column :dropbox_connections, :completed, :boolean
  end
end

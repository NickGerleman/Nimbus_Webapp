class ConvertGoogleToSerializedSession < ActiveRecord::Migration
  def change
    add_column :google_connections, :session, :string
  end
end

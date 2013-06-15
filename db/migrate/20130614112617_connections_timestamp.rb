class ConnectionsTimestamp < ActiveRecord::Migration
  def change
    add_timestamps :connections
  end
end

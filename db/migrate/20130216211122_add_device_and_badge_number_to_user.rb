class AddDeviceAndBadgeNumberToUser < ActiveRecord::Migration
  def change
		add_column :users, :device_id, :integer
		add_column :users, :badge_number, :integer
  end
end

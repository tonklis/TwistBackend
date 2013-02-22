class UsersHaveManyIosAndAndroidDevices < ActiveRecord::Migration
  def change
		remove_column :users, :device_id
		add_column :apn_devices, :user_id, :integer
		add_column :gcm_devices, :user_id, :integer
  end
end

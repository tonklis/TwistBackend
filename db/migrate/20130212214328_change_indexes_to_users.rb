class ChangeIndexesToUsers < ActiveRecord::Migration
  def change
		add_index :users, :facebook_id, :unique => true
		change_column :users, :email, :string, :null => true, :default => nil
  end
end

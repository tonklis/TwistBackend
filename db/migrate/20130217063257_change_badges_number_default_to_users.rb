class ChangeBadgesNumberDefaultToUsers < ActiveRecord::Migration
  def change 
		change_column :users, :badge_number, :integer, :null => false, :default => 0		
  end
end

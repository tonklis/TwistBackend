class AddIsHiddenToGames < ActiveRecord::Migration
  def change
  	add_column :games, :is_hidden, :boolean, :default => false
  end
end

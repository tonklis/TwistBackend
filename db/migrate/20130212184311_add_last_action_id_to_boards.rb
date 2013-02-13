class AddLastActionIdToBoards < ActiveRecord::Migration
  def change
  	add_column :boards, :last_action, :integer
  end
end

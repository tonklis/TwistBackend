class AddPreviousBoardToBoards < ActiveRecord::Migration
  def change
  	add_column :boards, :previous_board_id, :integer
  end
end

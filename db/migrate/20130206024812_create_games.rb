class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id
      t.integer :board_id
      t.integer :card_id
      t.integer :question_count
      t.integer :guess_count
      t.integer :opponent_game_id

      t.timestamps
    end
  end
end

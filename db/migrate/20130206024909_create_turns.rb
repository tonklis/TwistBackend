class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.integer :game_id
      t.string :question
      t.boolean :answer
      t.boolean :is_guess

      t.timestamps
    end
  end
end

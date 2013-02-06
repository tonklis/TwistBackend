class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :status
      t.text :detail_xml
      t.integer :winner_id
      t.integer :money_awarded

      t.timestamps
    end
  end
end

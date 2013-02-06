class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :description
      t.string :url
      t.integer :template_id

      t.timestamps
    end
  end
end

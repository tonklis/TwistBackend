class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_id
      t.string :first_name
      t.string :last_name
      t.integer :money, :default => 0

      t.timestamps
    end
  end
end

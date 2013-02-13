class AddFacebookIdToCards < ActiveRecord::Migration
  def change
  	add_column :cards, :facebook_id, :string
  end
end

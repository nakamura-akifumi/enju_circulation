class AddPlaceIdToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :place_id, :integer
    add_index :events, :place_id
  end
end

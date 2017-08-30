class AddRatingToPlaces < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :rating, :float
  end
end

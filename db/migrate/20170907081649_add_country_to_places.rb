class AddCountryToPlaces < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :country, :string
  end
end

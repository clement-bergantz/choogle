class AddApiGoogleIdToPlaces < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :api_google_id, :string
  end
end

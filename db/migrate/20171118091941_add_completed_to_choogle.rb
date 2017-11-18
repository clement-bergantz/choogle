class AddCompletedToChoogle < ActiveRecord::Migration[5.0]
  def change
    add_column :choogles, :completed, :boolean, default: false
  end
end

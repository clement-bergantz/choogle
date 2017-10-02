class AddTimecodeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :timecode, :string
  end
end

class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :choogle, foreign_key: true

      t.timestamps
    end
  end
end

class CreateProposals < ActiveRecord::Migration[5.0]
  def change
    create_table :proposals do |t|
      t.references :choogle, foreign_key: true
      t.references :place, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

class CreateChoogles < ActiveRecord::Migration[5.0]
  def change
    create_table :choogles do |t|
      t.string :title
      t.datetime :due_at
      t.datetime :happens_at
      t.references :user, foreign_key: true
      t.references :comment, foreign_key: true
      t.string :slug

      t.timestamps
    end
  end
end

class AddChoogleToComments < ActiveRecord::Migration[5.0]
  def change
    add_reference :comments, :choogle, foreign_key: true
  end
end

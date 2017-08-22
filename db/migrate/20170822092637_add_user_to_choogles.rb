class AddUserToChoogles < ActiveRecord::Migration[5.0]
  def change
    add_reference :choogles, :user, foreign_key: true
  end
end

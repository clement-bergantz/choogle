class RemoveCommentIdFromChoogles < ActiveRecord::Migration[5.0]
  def change
    remove_column :choogles, :comment_id
  end
end

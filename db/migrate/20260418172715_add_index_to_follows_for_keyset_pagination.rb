class AddIndexToFollowsForKeysetPagination < ActiveRecord::Migration[8.1]

  def change
    add_index :follows, %i[follower_id created_at id]
    add_index :follows, %i[following_id created_at id]
  end

end

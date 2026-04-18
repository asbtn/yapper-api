class AddIndexToPostsForKeysetPagination < ActiveRecord::Migration[8.1]

  def change
    add_index :posts, %i[created_at id]
    add_index :posts, %i[user_id created_at id]
  end

end

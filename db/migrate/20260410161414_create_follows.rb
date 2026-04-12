class CreateFollows < ActiveRecord::Migration[8.1]

  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :following, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :follows, %i[follower_id following_id], unique: true
    add_check_constraint :follows,
                         "follower_id <> following_id",
                         name: "follows_no_self_follow"
  end

end

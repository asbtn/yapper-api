class AddCountersToUsers < ActiveRecord::Migration[8.1]

  def change
    change_table :users, bulk: true do |t|
      t.integer :followers_count, default: 0, null: false
      t.integer :following_count, default: 0, null: false
      t.integer :posts_count, default: 0, null: false
    end
  end

end

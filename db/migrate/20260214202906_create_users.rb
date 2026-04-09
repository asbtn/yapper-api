class CreateUsers < ActiveRecord::Migration[8.0]

  def change
    create_table :users do |t|
      t.string :handle, null: false
      t.string :username, null: false
      t.string :bio, null: true
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.index :handle, unique: true

      t.timestamps
    end
  end

end

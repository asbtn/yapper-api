# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  bio             :string
#  email_address   :string           not null
#  handle          :string           not null
#  password_digest :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_handle  (handle) UNIQUE
#
FactoryBot.define do
  factory :user do
    handle { Faker::Internet.username }
    username { Faker::Name.first_name }
    bio { Faker::Lorem.sentence }
    email_address { Faker::Internet.email }
    password { "Password-1!" }
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string           not null
#  password_digest :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email_address, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

end

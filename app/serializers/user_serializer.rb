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
class UserSerializer

  include JSONAPI::Serializer

  attributes :id, :handle, :username, :bio, :email_address

end

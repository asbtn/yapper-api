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

  # == Extensions ===========================================================

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Relationships ========================================================

  # == Validations ==========================================================
  has_secure_password

  # TODO: Validate characters in username
  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 }

  validates :email_address,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  # TODO: Add password complexity
  validates :password,
            length: { minimum: 6 }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # == Instance Methods =====================================================

end

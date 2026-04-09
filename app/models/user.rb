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
class User < ApplicationRecord

  # == Extensions ===========================================================

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Relationships ========================================================
  has_many :posts, dependent: :destroy

  # == Validations ==========================================================
  has_secure_password

  # TODO: Validate characters in handle
  validates :handle,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 }

  validates :username,
            presence: true,
            length: { minimum: 3, maximum: 30 }

  validates :bio,
            length: { maximum: 300 }

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

  def self.find_by_identifier(identifier)
    where("handle = ? OR id::text = ?", identifier, identifier).take!
  end

  # == Instance Methods =====================================================
  def generate_jwt_token
    JwtToken.encode({ id: }, expiry: 7.days)
  end

end

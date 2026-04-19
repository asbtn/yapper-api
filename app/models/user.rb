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
  has_secure_password

  # == Constants ============================================================
  VALID_HANDLE_REGEX = /\A[a-z0-9_]+\z/i
  RESERVED_HANDLES = %w[me].freeze
  PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*\d).+\z/

  # == Attributes ===========================================================

  # == Relationships ========================================================
  has_many :posts, dependent: :destroy

  has_many :outgoing_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           inverse_of: :follower,
           dependent: :destroy

  has_many :incoming_follows,
           class_name: "Follow",
           foreign_key: :following_id,
           inverse_of: :following,
           dependent: :destroy

  has_many :following,
           through: :outgoing_follows,
           source: :following

  has_many :followers,
           through: :incoming_follows,
           source: :follower

  # == Validations ==========================================================
  validates :handle,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: {
              with: VALID_HANDLE_REGEX,
              message: I18n.t("errors.messages.handle_format")
            },
            exclusion: {
              in: RESERVED_HANDLES,
              message: I18n.t("errors.messages.handle_reserved")
            }

  validates :username,
            presence: true,
            length: { minimum: 3, maximum: 30 }

  validates :bio,
            length: { maximum: 300 }

  validates :email_address,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            length: { minimum: 6 },
            format: {
              with: PASSWORD_REGEX,
              message: I18n.t("errors.messages.password_format")
            },
            if: -> { password.present? }

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :handle, with: ->(h) { h.to_s.downcase }

  # == Instance Methods =====================================================
  def generate_jwt_token
    JwtToken.encode({ id: }, expiry: 7.days)
  end

end

class Follow < ApplicationRecord

  # == Extensions ===========================================================

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Relationships ========================================================
  belongs_to :follower,
             class_name: "User",
             inverse_of: :outgoing_follows,
             counter_cache: :following_count

  belongs_to :following,
             class_name: "User",
             inverse_of: :incoming_follows,
             counter_cache: :followers_count

  # == Validations ==========================================================
  validates :follower_id,
            uniqueness: { scope: :following_id }

  validate :prevent_self_follow

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  private

  def prevent_self_follow
    return unless follower_id == following_id

    errors.add(:following_id, I18n.t("errors.messages.cant_follow_self"))
  end

end

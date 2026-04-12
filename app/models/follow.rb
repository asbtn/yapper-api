class Follow < ApplicationRecord

  # == Extensions ===========================================================

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Relationships ========================================================
  belongs_to :follower,
             class_name: "User",
             inverse_of: :outgoing_follows

  belongs_to :following,
             class_name: "User",
             inverse_of: :incoming_follows

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

    errors.add(:following_id, "can't be the same as follower")
  end

end

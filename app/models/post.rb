# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord

  # == Extensions ===========================================================

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Relationships ========================================================
  belongs_to :user, counter_cache: true

  # == Validations ==========================================================
  validates :content, presence: true, length: { minimum: 1, maximum: 140 }

  # == Scopes ===============================================================
  scope :ordered, -> { order(created_at: :desc, id: :desc) }

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.timeline_for(user)
    where(
      "posts.user_id = :user_id OR EXISTS (
      SELECT 1 FROM follows
      WHERE follows.follower_id = :user_id
        AND follows.following_id = posts.user_id
    )",
      user_id: user.id
    )
      .includes(:user)
      .ordered
  end

  # == Instance Methods =====================================================

end

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

  # == Callbacks ============================================================

  # == Class Methods ========================================================
  def self.timeline_for(user)
    includes(:user)
      .where(user: user.following)
      .or(where(user: user))
      .order(created_at: :desc)
  end

  # == Instance Methods =====================================================

end

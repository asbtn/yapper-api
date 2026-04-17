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
require "rails_helper"

RSpec.describe Post, type: :model do
  subject { create(:post) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_length_of(:content).is_at_least(1).is_at_most(140) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe ".timeline_for" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:other_user) { create(:user) }

    let!(:own_post) { create(:post, user: user, created_at: 2.days.ago) }
    let!(:followed_post) { create(:post, user: followed_user, created_at: 1.day.ago) }
    let!(:other_post) { create(:post, user: other_user, created_at: Time.current) }

    before do
      create(:follow, follower: user, following: followed_user)
    end

    it "returns posts from user and followed users" do
      result = described_class.timeline_for(user)

      expect(result).to include(own_post, followed_post)
    end

    it "does not return posts from unrelated users" do
      result = described_class.timeline_for(user)

      expect(result).not_to include(other_post)
    end

    it "orders posts by newest first" do
      result = described_class.timeline_for(user)

      expect(result.first).to eq(followed_post)
      expect(result.second).to eq(own_post)
    end
  end
end

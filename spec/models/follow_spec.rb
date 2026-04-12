require "rails_helper"

RSpec.describe Follow, type: :model do
  subject { create(:follow) }

  describe "associations" do
    it { is_expected.to belong_to(:follower).class_name("User").inverse_of(:outgoing_follows) }
    it { is_expected.to belong_to(:following).class_name("User").inverse_of(:incoming_follows) }
  end

  describe "validations" do
    it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:following_id) }
  end

  describe "custom validations" do
    it "does not allow self follow" do
      user = create(:user)
      follow = build(:follow, follower: user, following: user)

      expect(follow).not_to be_valid
      expect(follow.errors[:following_id]).to include("can't be the same as follower")
    end
  end
end

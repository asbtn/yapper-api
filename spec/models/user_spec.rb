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
require "rails_helper"

describe User, type: :model do
  subject(:user) { create(:user) }

  describe "associations" do
    it { is_expected.to have_many(:posts) }

    it do
      expect(user).to have_many(:outgoing_follows)
        .class_name("Follow")
        .with_foreign_key(:follower_id)
        .inverse_of(:follower)
        .dependent(:destroy)
    end

    it do
      expect(user).to have_many(:incoming_follows)
        .class_name("Follow")
        .with_foreign_key(:following_id)
        .inverse_of(:following)
        .dependent(:destroy)
    end

    it { is_expected.to have_many(:following).through(:outgoing_follows).source(:following) }
    it { is_expected.to have_many(:followers).through(:incoming_follows).source(:follower) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:handle) }

    it { is_expected.to validate_presence_of(:email_address) }
    it { is_expected.to validate_uniqueness_of(:handle).case_insensitive }
    it { is_expected.to allow_value("test@example.com").for(:email_address) }
    it { is_expected.not_to allow_value("te st@e.jj").for(:email_address) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "normalizations" do
    it { is_expected.to normalize(:email_address).from(" [email protected]\n").to("[email protected]") }
    it { is_expected.to normalize(:email_address).from("USER@EXAMPLE.COM").to("user@example.com") }
  end

  it "returns followers and following users" do
    user = create(:user)
    followed_user = create(:user)
    follower_user = create(:user)

    create(:follow, follower: user, following: followed_user)
    create(:follow, follower: follower_user, following: user)

    expect(user.following).to contain_exactly(followed_user)
    expect(user.followers).to contain_exactly(follower_user)
  end
end

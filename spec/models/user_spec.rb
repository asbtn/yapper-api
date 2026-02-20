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
require "rails_helper"

describe User, type: :model do
  subject { create(:user, password: "password-1") }

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email_address) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to allow_value("test@example.com").for(:email_address) }
    it { is_expected.not_to allow_value("te st@e.jj").for(:email_address) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe "normalizations" do
    it { is_expected.to normalize(:email_address).from(" [email protected]\n").to("[email protected]") }
    it { is_expected.to normalize(:email_address).from("USER@EXAMPLE.COM").to("user@example.com") }
  end
end

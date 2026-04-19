require "rails_helper"

describe Users::Create, type: :service do
  subject(:service) { described_class.call(params) }

  context "when params are valid" do
    let(:params) do
      {
        username: "test-user",
        handle: "test_handle",
        email_address: "user@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    end

    it "is success" do
      expect(service).to be_success
    end

    it "creates user" do
      expect { service }.to change(User, :count).by(1)
    end

    it "returns persisted user in result" do
      expect(service.result).to be_persisted
    end

    it "creates user with correct attributes" do
      expect(service.result.attributes).to include(
        { "username" => "test-user",
          "email_address" => "user@example.com" }
      )
    end
  end

  context "when params are invalid" do
    let(:params) do
      {
        username: "",
        email_address: "invalid-email",
        password: "short",
        password_confirmation: "mismatch"
      }
    end

    it "is failure" do
      expect(service).to be_failure
    end

    it "has validation errors" do
      expect(service.errors).to include(
        handle: ["can't be blank", "is too short (minimum is 3 characters)",
                 "can only contain letters, numbers, and underscores"],
        username: ["can't be blank", "is too short (minimum is 3 characters)"],
        email_address: ["is invalid"],
        password: ["is too short (minimum is 6 characters)", "must include at least one letter and one number"],
        password_confirmation: ["doesn't match Password"]
      )
    end

    it "does not create user" do
      expect { service }.not_to change(User, :count)
    end
  end
end

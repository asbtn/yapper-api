require "rails_helper"

describe Sessions::Create, type: :service do
  subject(:service) { described_class.call(params) }

  let(:user) { create(:user, password: "correct1") }

  context "when credentials are correct" do
    let(:params) do
      { email_address: user.email_address, password: "correct1" }
    end

    it "is success" do
      expect(service).to be_success
    end

    it "returns valid JWT token in result" do
      token = service.result[:token]
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base).first

      expect(decoded.dig("data", "id")).to eq(user.id)
    end

    it "returns result with user" do
      expect(service.result[:user]).to eq(user)
    end
  end

  context "when credentials are invalid" do
    let(:params) do
      { email_address: user.email_address, password: "incorrect" }
    end

    it "is failure" do
      expect(service).to be_failure
    end

    it "has errors" do
      expect(service.errors.full_messages).to eq ["Invalid credentials"]
    end
  end

  context "when user is not found" do
    let(:params) do
      { email_address: "invalid@email.com", password: "correct" }
    end

    it "is failure" do
      expect(service).to be_failure
    end

    it "has errors" do
      expect(service.errors.full_messages).to eq ["Invalid credentials"]
    end
  end
end

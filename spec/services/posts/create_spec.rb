require "rails_helper"

describe Posts::Create, type: :service do
  subject(:service) { described_class.call(user, params) }

  let(:user) { create(:user) }

  context "when params are valid" do
    let(:params) do
      {
        content: "Hello World!"
      }
    end

    it "is success" do
      expect(service).to be_success
    end

    it "creates post" do
      expect { service }.to change(Post, :count).by(1)
    end

    it "returns persisted post in result" do
      expect(service.result).to be_persisted
    end

    it "creates post with correct attributes" do
      expect(service.result.attributes).to include(
        { "content" => "Hello World!" }
      )
    end

    it "associates post with correct user" do
      expect(service.result.user).to eq user
    end
  end

  context "when params are invalid" do
    let(:params) do
      {
        content: ""
      }
    end

    it "is failure" do
      expect(service).to be_failure
    end

    it "has validation errors" do
      expect(service.errors).to include(
        content: ["can't be blank", "is too short (minimum is 1 character)"]
      )
    end

    it "does not create post" do
      expect { service }.not_to change(Post, :count)
    end
  end
end

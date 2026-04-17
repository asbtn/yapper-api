require "swagger_helper"

RSpec.describe "Timelines API", type: :request do
  let(:user) { create(:user) }
  let(:Authorization) { authorization_token(user) }

  path "/v1/timeline" do
    get "Retrieve current user's timeline" do
      tags "Timeline"

      produces "application/json"

      security [{ jwt: [] }]

      response "200", "timeline retrieved successfully" do
        let!(:followed_user) { create(:user) }
        let!(:own_post) { create(:post, user: user, content: "My post", created_at: 2.days.ago) }
        let!(:followed_post) do
          create(:post, user: followed_user, content: "Followed user's post", created_at: 1.day.ago)
        end

        before do
          create(:post, content: "Other user's post")
          create(:follow, follower: user, following: followed_user)
        end

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: POST_RESOURCE_OBJECT_SCHEMA
                 },
                 included: {
                   type: :array,
                   items: PUBLIC_USER_RESOURCE_OBJECT_SCHEMA
                 }
               },
               required: %w[data included]

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data["data"].size).to eq 2
          expect(data["data"][0]["attributes"]["content"]).to eq followed_post.content
          expect(data["data"][1]["attributes"]["content"]).to eq own_post.content

          user_ids = data["data"].map { |item| item["relationships"]["user"]["data"]["id"] }
          expect(user_ids).to contain_exactly(user.id.to_s, followed_user.id.to_s)
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end
    end
  end
end

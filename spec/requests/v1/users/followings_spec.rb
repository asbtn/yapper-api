require "swagger_helper"

RSpec.describe "Users followings API", type: :request do
  let(:path_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_id) { path_user.id }
  let(:Authorization) { authorization_token(current_user) }

  path "/v1/users/{user_id}/followings" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    get "List users this user follows" do
      tags "Follows"

      produces "application/json"
      security [{ jwt: [] }]

      response "200", "followings retrieved successfully" do
        let!(:follow_record) { create(:follow, follower: path_user, following: other_user) }

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: PUBLIC_USER_RESOURCE_OBJECT_SCHEMA
                 },
                 meta: {
                   type: :object,
                   properties: {
                     next: { type: :object, nullable: true }
                   },
                   required: %w[next]
                 }
               },
               required: %w[data meta]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"].pluck("attributes").pluck("handle")).to eq [follow_record.following.handle]
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end

      response "404", "user not found" do
        let(:user_id) { "999" }

        run_test!
      end
    end
  end
end

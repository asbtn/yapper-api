require "swagger_helper"

RSpec.describe "Users followers API", type: :request do
  let(:path_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:user_id) { path_user.id }
  let(:Authorization) { authorization_token(current_user) }

  path "/v1/users/{user_id}/followers" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    get "List user's followers" do
      tags "Follows"

      produces "application/json"
      security [{ jwt: [] }]

      response "200", "followers retrieved successfully" do
        let!(:follow_record) { create(:follow, follower: current_user, following: path_user) }

        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: USER_RESOURCE_OBJECT_SCHEMA
                 }
               },
               required: %w[data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"].pluck("attributes").pluck("handle")).to eq [follow_record.follower.handle]
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

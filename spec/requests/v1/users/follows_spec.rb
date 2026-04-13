require "swagger_helper"

RSpec.describe "Users follows API", type: :request do
  let(:path_user) { create(:user) }
  let(:current_user) { create(:user) }
  let(:user_id) { path_user.id }
  let(:Authorization) { authorization_token(current_user) }

  path "/v1/users/{user_id}/follow" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    post "Follow user" do
      tags "Follows"

      produces "application/json"
      security [{ jwt: [] }]

      response "201", "user followed successfully" do
        schema type: :object,
               properties: {
                 data: PUBLIC_USER_RESOURCE_OBJECT_SCHEMA
               },
               required: %w[data]

        run_test! do |_response|
          expect(
            Follow.exists?(
              follower: current_user,
              following: path_user
            )
          ).to be true
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

      response "422", "validation failed" do
        let(:path_user) { current_user }

        run_test!
      end
    end

    delete "Unfollow user" do
      tags "Follows"

      produces "application/json"
      security [{ jwt: [] }]

      response "204", "user unfollowed successfully" do
        let!(:follow_record) do
          create(:follow, follower: current_user, following: path_user)
        end

        run_test! do
          expect(Follow.exists?(follow_record.id)).to be false
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end

      response "404", "follow not found" do
        let(:user_id) { "999" }

        run_test!
      end
    end
  end
end

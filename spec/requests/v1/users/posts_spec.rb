require "swagger_helper"

RSpec.describe "Users Posts API", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:existing_post) { create(:post, user: user) }
  let(:Authorization) { authorization_token(user) }

  path "/v1/users/{user_id}/posts" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    get "List user's posts" do
      tags "Posts"

      produces "application/json"

      security [{ jwt: [] }]

      response "200", "posts retrieved successfully" do
        let!(:user_post) { create(:post, user: user) }

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

          expect(data["data"].size).to eq 1
          expect(data["data"][0]["attributes"]["content"]).to eq user_post.content
          expect(data["data"][0]["relationships"]["user"]["data"]["id"]).to eq user.id.to_s

          if data["included"].present?
            expect(data["included"][0]["type"]).to eq "public_user"
            expect(data["included"][0]["id"]).to eq user.id.to_s
          end
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

  path "/v1/users/{user_id}/posts/{id}" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"
    parameter name: :id, in: :path, type: :string, description: "Post ID"

    get "Show a post" do
      tags "Posts"
      produces "application/json"
      security [{ jwt: [] }]

      response "200", "post retrieved successfully" do
        let(:user_id) { existing_post.user.id }
        let(:id) { existing_post.id }

        schema type: :object,
               properties: {
                 data: POST_RESOURCE_OBJECT_SCHEMA,
                 included: {
                   type: :array,
                   items: PUBLIC_USER_RESOURCE_OBJECT_SCHEMA
                 }
               },
               required: %w[data included]

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data["data"]["id"]).to eq existing_post.id.to_s
          expect(data["data"]["attributes"]["content"]).to eq existing_post.content
          expect(data["data"]["relationships"]["user"]["data"]["id"]).to eq user.id.to_s

          if data["included"].present?
            expect(data["included"][0]["type"]).to eq "public_user"
            expect(data["included"][0]["id"]).to eq user.id.to_s
          end
        end
      end

      response "401", "unauthorized" do
        let(:user_id) { existing_post.user.id }
        let(:id) { existing_post.id }
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end

      response "404", "user or post not found" do
        let(:user_id) { user.id }
        let(:id) { "999" }

        run_test!
      end
    end
  end
end

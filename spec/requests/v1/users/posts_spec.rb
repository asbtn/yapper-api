require "swagger_helper"

RSpec.describe "Users Posts API", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:existing_post) { create(:post, user: user) }
  let(:valid_post_content) { "Hello world!" }
  let(:Authorization) { authorization_token }

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
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string, example: "post" },
                       attributes: {
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           content: { type: :string },
                           created_at: { type: :string, format: :date_time }
                         },
                         required: %w[id content created_at]
                       },
                       relationships: {
                         type: :object,
                         properties: {
                           user: {
                             type: :object,
                             properties: {
                               data: {
                                 type: :object,
                                 properties: {
                                   id: { type: :string },
                                   type: { type: :string, example: "user" }
                                 }
                               }
                             }
                           }
                         }
                       },
                       included: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: USER_RESOURCE_OBJECT_SCHEMA
                         }
                       }
                     }
                   }
                 }
               },
               required: %w[data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"].size).to eq 1
          expect(data["data"][0]["attributes"]["content"]).to eq user_post.content
        end
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
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string, example: "post" },
                     attributes: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         content: { type: :string },
                         created_at: { type: :string, format: :date_time }
                       },
                       required: %w[id content created_at]
                     },
                     relationships: {
                       type: :object,
                       properties: {
                         user: {
                           type: :object,
                           properties: {
                             data: {
                               type: :object,
                               properties: {
                                 id: { type: :string },
                                 type: { type: :string, example: "user" }
                               }
                             }
                           }
                         }
                       }
                     }
                   },
                   required: %w[id type attributes relationships]
                 }
               },
               required: %w[data]

        run_test!
      end

      response "404", "user not found" do
        let(:user_id) { "999" }
        let(:id) { existing_post.id }

        run_test!
      end

      response "404", "post not found" do
        let(:user_id) { user.id }
        let(:id) { "999" }

        run_test!
      end
    end
  end
end

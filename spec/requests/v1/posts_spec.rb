require "swagger_helper"

RSpec.describe "Users Posts API", type: :request do
  let(:user) { create(:user) }
  let(:existing_post) { create(:post, user: user) }
  let(:valid_post_content) { "Hello world!" }
  let(:Authorization) { authorization_token(user) }

  path "/v1/posts" do
    post "Create a post" do
      tags "Posts"

      consumes "application/json"
      produces "application/json"
      security [{ jwt: [] }]

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          post: {
            type: :object,
            properties: {
              content: { type: :string, example: "Hello world!" }
            },
            required: %w[content]
          }
        }
      }

      response "201", "post created successfully" do
        let(:body) { { post: { content: valid_post_content } } }

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

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]["attributes"]["content"]).to eq valid_post_content
          expect(user.posts.last.content).to eq valid_post_content
        end
      end

      response "401", "unauthorized" do
        let(:body) { { post: { content: valid_post_content } } }
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end

      response "422", "validation failed - blank content" do
        let(:body) { { post: { content: "" } } }

        schema VALIDATION_ERRORS_RESPONSE_SCHEMA

        run_test!
      end

      response "400", "missing nested post params" do
        let(:body) { { post: {} } }

        run_test!
      end

      response "400", "missing post param" do
        let(:body) { {} }

        run_test!
      end
    end
  end

  path "/v1/posts/{id}" do
    parameter name: :id, in: :path, type: :string, description: "Post ID"

    delete "Delete a post" do
      tags "Posts"

      security [{ jwt: [] }]

      response "204", "post deleted successfully" do
        let(:id) { existing_post.id }

        run_test! do |response|
          expect(response.status).to eq 204
          expect { existing_post.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      response "401", "unauthorized" do
        let(:id) { existing_post.id }
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end

      response "404", "post not found" do
        let(:id) { "999" }

        run_test!
      end
    end
  end
end

# rubocop:disable RSpec/MultipleMemoizedHelpers
require "swagger_helper"

RSpec.describe "Users Posts API", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:existing_post) { create(:post, user: user) }
  let(:valid_post_content) { "Hello world!" }
  let(:Authorization) { authorization_token } # rubocop:disable RSpec/VariableName

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
        let(:Authorization) { invalid_authorization_token } # rubocop:disable RSpec/VariableName

        run_test!
      end

      response "422", "validation failed - blank content" do
        let(:body) { { post: { content: "" } } }

        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     full_messages: {
                       type: :array,
                       items: { type: :string },
                       example: ["Content can't be blank"]
                     },
                     details: {
                       type: :object,
                       properties: {
                         content: { type: %i[string array], items: { type: :string } }
                       }
                     }
                   },
                   required: %w[full_messages details]
                 }
               },
               required: %w[errors]

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

    delete "Delete a post" do
      tags "Posts"

      security [{ jwt: [] }]

      response "204", "post deleted successfully" do
        let(:user_id) { existing_post.user.id }
        let(:id) { existing_post.id }

        run_test! do |response|
          expect(response.status).to eq 204
          expect { existing_post.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      response "401", "unauthorized" do
        let(:user_id) { existing_post.user.id }
        let(:id) { existing_post.id }
        let(:Authorization) { invalid_authorization_token } # rubocop:disable RSpec/VariableName

        run_test!
      end

      response "404", "user not found" do
        let(:user_id) { "999" }
        let(:id) { existing_post.id }

        run_test!
      end

      response "404", "post not found" do
        let(:id) { "999" }

        run_test!
      end
    end
  end
end

# rubocop:enable RSpec/MultipleMemoizedHelpers

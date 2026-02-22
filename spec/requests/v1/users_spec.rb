require "swagger_helper"

RSpec.describe "Users API", type: :request do
  path "/v1/users" do
    post "Create user (signup)" do
      tags "Authentication"

      consumes "application/json"
      produces "application/json"

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              username: { type: :string, example: "test-user" },
              email_address: { type: :string, example: "test@example.com" },
              password: { type: :string, example: "SecurePass123!" },
              password_confirmation: { type: :string, example: "SecurePass123!" }
            },
            required: %w[username email_address password password_confirmation]
          }
        }
      }

      response "201", "user created successfully" do
        let(:body) do
          {
            user: {
              username: "test-user",
              email_address: "test@example.com",
              password: "SecurePass123!",
              password_confirmation: "SecurePass123!"
            }
          }
        end

        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string, example: "user" },
                     attributes: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         username: { type: :string },
                         email_address: { type: :string }
                       },
                       required: %w[id username email_address]
                     }
                   },
                   required: %w[id type attributes]
                 }
               },
               required: %w[data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]["attributes"]["username"]).to eq "test-user"
          expect(data["data"]["attributes"]["email_address"]).to eq "test@example.com"
        end
      end

      response "422", "validation failed" do
        let(:body) do
          {
            user: {
              username: "",
              email_address: "invalid-email",
              password: "short",
              password_confirmation: "mismatch"
            }
          }
        end

        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     full_messages: {
                       type: :array,
                       items: { type: :string },
                       example: ["Username can't be blank", "Email address is invalid"]
                     },
                     details: {
                       type: :object,
                       properties: {
                         username: {
                           type: %i[string array],
                           items: { type: :string }
                         },
                         email_address: {
                           type: %i[string array],
                           items: { type: :string }
                         },
                         password: {
                           type: %i[string array],
                           items: { type: :string }
                         },
                         password_confirmation: {
                           type: %i[string array],
                           items: { type: :string }
                         }
                       },
                       additionalProperties: false
                     }
                   },
                   required: %w[full_messages details]
                 }
               },
               required: %w[errors]

        run_test!
      end

      response "422", "username" do
        let!(:existing_user) { create(:user) }
        let(:body) do
          {
            user: {
              username: existing_user.username,
              email_address: "test@example.com",
              password: "SecurePass123!",
              password_confirmation: "SecurePass123!"
            }
          }
        end

        run_test!
      end

      response "422", "username already taken" do
        let!(:existing_user) { create(:user) }
        let(:body) do
          {
            user: {
              username: existing_user.username,
              email_address: "unique@example.com",
              password: "SecurePass123!",
              password_confirmation: "SecurePass123!"
            }
          }
        end

        run_test!
      end

      response "400", "missing nested user params" do
        let(:body) do
          {
            user: {}
          }
        end

        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     full_messages: {
                       type: :array,
                       items: { type: :string },
                       example: ["User can't be blank"]
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end
end

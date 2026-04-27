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
              handle: { type: :string, example: "test-handle" },
              username: { type: :string, example: "test-user" },
              bio: { type: :string, example: "This is a test user." },
              email_address: { type: :string, example: "test@example.com" },
              password: { type: :string, example: "SecurePass123!" },
              password_confirmation: { type: :string, example: "SecurePass123!" }
            },
            required: %w[username handle email_address password password_confirmation]
          }
        },
        required: %w[user]
      }

      response "201", "user created successfully" do
        let(:body) do
          {
            user: {
              username: "test-user",
              handle: "test_handle",
              bio: "This is a test user.",
              email_address: "test@example.com",
              password: "SecurePass123!",
              password_confirmation: "SecurePass123!"
            }
          }
        end

        schema type: :object,
               properties: {
                 data: PRIVATE_USER_RESOURCE_OBJECT_SCHEMA
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

        schema VALIDATION_ERRORS_RESPONSE_SCHEMA

        run_test!
      end

      response "400", "missing nested user params" do
        let(:body) do
          {
            user: {}
          }
        end

        schema VALIDATION_ERRORS_RESPONSE_SCHEMA

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
    end
  end

  path "/v1/users/{id}" do
    parameter name: :id, in: :path, type: :string, description: "User ID"

    get "Show a user" do
      tags "Users"
      produces "application/json"
      security [{ jwt: [] }]

      response "200", "user retrieved successfully" do
        let(:Authorization) { authorization_token }
        let(:id) { create(:user).id }

        schema type: :object,
               properties: {
                 data: PUBLIC_USER_RESOURCE_OBJECT_SCHEMA,
                 meta: {
                   type: :object,
                   properties: {
                     followed_by_current_user: { type: :boolean },
                     follows_current_user: { type: :boolean }
                   },
                   required: %w[followed_by_current_user follows_current_user]
                 }
               },
               required: %w[data meta]

        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { invalid_authorization_token }
        let(:id) { create(:user).id }

        run_test!
      end

      response "404", "user not found" do
        let(:Authorization) { authorization_token }
        let(:id) { "999" }

        run_test!
      end
    end
  end

  path "/v1/users/me" do
    get "Retrieve current user" do
      tags "Users"
      produces "application/json"
      security [{ jwt: [] }]

      response "200", "current user retrieved successfully" do
        let(:current_user) { create(:user) }
        let(:Authorization) { authorization_token(current_user) }

        schema type: :object,
               properties: {
                 data: PRIVATE_USER_RESOURCE_OBJECT_SCHEMA
               },
               required: %w[data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["data"]["attributes"]["username"]).to eq current_user.username
          expect(data["data"]["attributes"]["email_address"]).to eq current_user.email_address
        end
      end

      response "401", "unauthorized" do
        let(:Authorization) { invalid_authorization_token }

        run_test!
      end
    end
  end
end

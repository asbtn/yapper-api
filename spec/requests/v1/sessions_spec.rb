require "swagger_helper"

RSpec.describe "Sessions API", type: :request do
  path "/v1/sessions" do
    post "Create session (login)" do
      tags "Authentication"

      consumes "application/json"
      produces "application/json"

      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          email_address: { type: :string, example: "test@example.com" },
          password: { type: :string, example: "password123" }
        },
        required: %w[email_address password]
      }

      response "201", "authenticated successfully" do
        let(:user) { create(:user, password: "password123") }
        let(:session) do
          {
            email_address: user.email_address,
            password: "password123"
          }
        end

        schema type: :object,
               properties: {
                 token: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 12 },
                     email_address: { type: :string, example: "test@example.com" },
                     username: { type: :string, example: "test-user" }
                   }
                 }
               },
               required: %w[token user]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["token"]).to be_present
          expect(data["user"]["email_address"]).to eq(user.email_address)
        end
      end

      response "401", "authentication failed" do
        let(:session) do
          {
            email_address: "test@example.com",
            password: "wrong"
          }
        end

        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   properties: {
                     full_messages: { type: :array, items: { type: :string } },
                     details: {
                       type: :object,
                       properties: {
                         base: { type: :array, items: { type: :string } }
                       }
                     }
                   },
                   required: %w[full_messages details]
                 }
               },
               required: %w[errors]
        run_test!
      end
    end
  end
end

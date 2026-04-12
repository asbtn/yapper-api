USER_RESOURCE_OBJECT_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string },
    type: { type: :string, example: "user" },
    attributes: {
      type: :object,
      properties: {
        id: { type: :integer },
        handle: { type: :string },
        username: { type: :string },
        bio: { type: :string },
        email_address: { type: :string }
      },
      required: %w[id username handle email_address]
    }
  },
  required: %w[id type attributes]
}.freeze

VALIDATION_ERRORS_RESPONSE_SCHEMA = {
  type: :object,
  properties: {
    errors: {
      type: :object,
      properties: {
        full_messages: {
          type: :array,
          items: { type: :string }
        },
        details: { type: :object }
      },
      required: %w[full_messages details]
    }
  },
  required: %w[errors]
}.freeze

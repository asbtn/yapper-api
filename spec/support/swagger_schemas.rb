PUBLIC_USER_RESOURCE_OBJECT_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string },
    type: { type: :string, example: "user" },
    attributes: {
      type: :object,
      properties: {
        handle: { type: :string },
        username: { type: :string },
        bio: { type: :string, nullable: true }
      },
      required: %w[username handle]
    }
  },
  required: %w[id type attributes]
}.freeze

PRIVATE_USER_RESOURCE_OBJECT_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string },
    type: { type: :string, example: "user" },
    attributes: {
      type: :object,
      properties: {
        handle: { type: :string },
        username: { type: :string },
        bio: { type: :string, nullable: true },
        email_address: { type: :string }
      },
      required: %w[username handle email_address]
    }
  },
  required: %w[id type attributes]
}.freeze

POST_RESOURCE_OBJECT_SCHEMA = {
  type: :object,
  properties: {
    id: { type: :string },
    type: { type: :string, example: "post" },
    attributes: {
      type: :object,
      properties: {
        content: { type: :string },
        created_at: { type: :string, format: :"date-time" }
      },
      required: %w[content created_at]
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
              },
              required: %w[id type]
            }
          },
          required: %w[data]
        }
      },
      required: %w[user]
    }
  },
  required: %w[id type attributes relationships]
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

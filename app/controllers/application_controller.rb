class ApplicationController < ActionController::API

  include Authentication

  private

  # TODO: Add rescuing errors
  # TODO: Add basic responses like 404

  def render_success(serializer, status: :ok)
    render json: serializer.serializable_hash, status: status
  end

  def render_errors(errors, status: :unprocessable_entity)
    render json: {
      errors: {
        full_messages: errors.full_messages,
        details: errors.to_hash
      }
    }, status: status
  end

end

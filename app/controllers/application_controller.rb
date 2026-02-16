class ApplicationController < ActionController::API

  include Authentication

  private

  def render_success(serializer, status: :ok)
    render json: serializer.serializable_hash, status: status
  end

  def render_errors(errors, status: :unprocessable_entity)
    serialized = if errors.is_a?(Hash)
                   ErrorSerializer.from_hash(errors)
                 else
                   ErrorSerializer.new(errors)
                 end

    render json: serialized.serializable_hash, status: status
  end

end

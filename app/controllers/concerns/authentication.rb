module Authentication

  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate, options
    end
  end

  private

  def authorization_token
    return unless request.headers["Authorization"]&.start_with?("Bearer ")

    request.headers["Authorization"].split.last
  end

  def current_user
    @current_user ||= authorization_token && begin
      decoded = JwtToken.decode(authorization_token)
      User.find(decoded[:data][:id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      nil
    end
  end

  def authenticate
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

end

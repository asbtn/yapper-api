class ApplicationController < ActionController::API

  include Authentication
  include Pagy::Method

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_success(serializer, status: :ok)
    render json: serializer.serializable_hash, status: status
  end

  def render_error(status:, message: nil, details: nil)
    message ||= status.to_s.humanize

    error = { message: message }
    error[:details] = details if details.present?

    render json: { error: error }, status: status
  end

  def render_invalid(errors)
    render_error(
      status: :unprocessable_entity,
      message: I18n.t("errors.messages.request_failed"),
      details: normalize_error_details(errors)
    )
  end

  def render_not_found(_error)
    render_error(status: :not_found)
  end

  def render_bad_request(error)
    render_error(
      status: :bad_request,
      message: error.message
    )
  end

  def limit
    config = Rails.configuration.x.pagination
    requested = params.dig(:page, :size).to_i

    requested = config.default_page_size if requested <= 0
    [requested, config.max_page_size].min
  end

  def normalize_error_details(errors)
    errors.to_hash.transform_values do |value|
      Array(value)
    end
  end

end

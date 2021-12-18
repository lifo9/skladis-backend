class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  before_action :set_locale

  delegate :t, to: I18n

  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden

  private

  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  def set_locale
    locale = request.headers["Locale"]&.to_sym

    I18n.locale = locale if I18n.available_locales.include?(locale)
  end

  def bad_request
    render json: { error: t(:bad_request) }, status: :bad_request
  end

  def forbidden
    render json: { error: t(:forbidden) }, status: :forbidden
  end

  def not_authorized
    render json: { error: t(:not_authorized) }, status: :unauthorized
  end

  def not_found
    render json: { error: t(:not_found) }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.record.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end
end

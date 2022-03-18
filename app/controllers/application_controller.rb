class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  include Pundit::Authorization

  before_action :set_locale
  before_action :set_paper_trail_whodunnit

  delegate :t, to: I18n

  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
  rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  def api_index(model_class, params, associations = true)
    items = model_class.all

    if items.respond_to?(:api_filter)
      items = items.api_filter(params, associations)
    end
    if items.respond_to?(:search_all_fields)
      items = items.search_all_fields(params[:search], associations) if params[:search]
    end
    if items.respond_to?(:api_order_by)
      items = items.api_order_by(params[:order_by], params[:order], associations) if params[:order_by] || params[:order]
    end

    paginate items
  end

  def api_select_options(model_class, label_columns, value_column, params, associations = true)
    items = model_class.all

    if items.respond_to?(:api_filter)
      items = items.api_filter(params, associations)
    end
    if items.respond_to?(:search_all_fields)
      items = items.search_all_fields(params[:search], associations) if params[:search]
    end
    if items.respond_to?(:api_order_by)
      items = items.api_order_by(params[:order_by], params[:order], associations) if params[:order_by] || params[:order]
    end

    items.pluck(*label_columns, value_column)
         .map do |columns|
      {
        id: columns.last,
        label: columns[0...-1].join(' ')
      }
    end
  end

  private

  def current_user
    token = request_cookies[JWTSessions.cookie_by(:access)]
    if JWTSessions::Session.new.session_exists?(token)
      decode_options = { algorithm: JWTSessions.algorithm }
      payload = JWT.decode(token, JWTSessions.public_key, false, decode_options)
      @current_user = User.find(payload[0]['user_id'])
    else
      @current_user = nil
    end
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

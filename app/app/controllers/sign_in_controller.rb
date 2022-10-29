class SignInController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  def create
    user = User.find_by!(email: params[:email])

    if user.authenticate(params[:password]) && user.active
      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true, namespace: "user_#{user.id}")
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: true,
                          same_site: Rails.env.production? ? :Strict : :None)

      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    session = JWTSessions::Session.new(payload: payload, namespace: "user_#{payload['user_id']}")
    session.flush_by_access_payload
    render json: :ok
  end
end

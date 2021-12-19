class SignUpController < ApplicationController
	def create
		invitation = RegistrationInvitation.find_by(user: nil, key: params[:registration_key], used: false)
		return not_authorized unless invitation.present?

		user = User.new(user_params)
		if user.save
			invitation.update!(user: user, used: true)
			payload = { user_id: user.id }
			session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
			tokens = session.login

			response.set_cookie(JWTSessions.access_cookie,
			                    value: tokens[:access],
			                    httponly: true,
			                    secure: Rails.env.production?)
			render json: { csrf: tokens[:csrf] }
		else
			render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
		end
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
	end
end

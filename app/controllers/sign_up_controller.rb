class SignUpController < ApplicationController
  def create
    invitation = RegistrationInvitation.find_by(user: nil, registration_key: params[:registration_key], used: false)
    return not_authorized unless invitation.present?

    user = User.new(user_params)
    if user.save
      invitation.update!(user: user, used: true)

      UserMailer.with(user: user).registration.deliver_later

      head :ok
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def activate
    invitation = RegistrationInvitation.find_by(activation_key: activate_params[:activation_key])
    user = invitation&.user
    activated = user&.active

    if invitation.present? && !activated
      user.update!(active: true)

      head :ok
    else
      bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def activate_params
    params.permit([:activation_key])
  end
end

class UserMailer < ApplicationMailer
  delegate :t, to: I18n

  def registration
    user = params[:user]
    @activation_link = Rails.configuration.x.frontend_url + '/sign-up/activate/' + user.registration_invitation.activation_key

    mail(to: user.email, subject: t(:'mail.registration.subject'))
  end
end

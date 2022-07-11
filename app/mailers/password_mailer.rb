class PasswordMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @token = @user.signed_id(expires_in: 15.minutes, purpose: "password_reset")
    mail(to: @user.email,
         subject: "Reset your password!")
  end
end
class PasswordMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @reset_token = params[:reset_token]
    mail(to: @user.email,
         subject: "Reset your password!")
  end
end
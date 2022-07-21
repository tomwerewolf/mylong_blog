class PasswordMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @reset_token = params[:reset_token]
    mail(to: @user.email,
         subject: I18n.t("mails.subjects.password_reset") )
  end
end
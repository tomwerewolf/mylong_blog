class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://127.0.0.1:3000/login'
    mail(to: @user.email,
         subject: 'Welcome to Mylong Blog!')
  end
end
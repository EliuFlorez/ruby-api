class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Reset Password')
  end

  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirmation')
  end

  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Activation')
  end
end

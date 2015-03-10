class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url = 'http://localhost:9393/'
    mail(to: @user.email, subject: 'What rhymes with ornages?')
  end
end

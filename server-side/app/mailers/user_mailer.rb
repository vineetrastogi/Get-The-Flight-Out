class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url = 'http://localhost:9393/'
    mail(to: @user.email, subject: 'Hi #{@user.name}, this is link: #{@user.link}')
  end
end

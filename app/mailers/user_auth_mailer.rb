class UserAuthMailer < ApplicationMailer
  def send_link(user, url)
    @user = user
    @url  = url
    @host = Rails.application.config.hosts.first
    mail to: @user.email, subject: 'Sign in into #{@host}'
  end
end

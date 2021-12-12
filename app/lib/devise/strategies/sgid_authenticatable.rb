require 'devise/strategies/authenticatable'
require_relative '../../../mailers/user_auth_mailer'

module Devise
  module Strategies
    class SgidAuthenticatable < Authenticatable

      # triggered by sign_on request
      def authenticate!
        email = params.dig(:user, :email)
        user = User.find_by(email: email)

        if user.present?
          user_sgid = user.to_sgid(expires_in: 1.hour, for: 'user_auth')
          auth_token= user_sgid.to_s
          auth_url = Rails.application.routes.url_helpers
                          .auth_user_session_url(auth_token: auth_token)
          UserAuthMailer.send_link(user, auth_url).deliver_later
        end
        fail!("An email was sent to you with a magic link.")
        # flash[:notice] = "Please check your email for the access link"
        # redirect_to root_path
      end

      protected

      # def gererate_auth_url(user, time_to_live, usage)
      #   user_sgid = user.to_sgid(expires_in: time_to_live, for: usage)
      #   auth_token= user_sgid.to_s
      #   auth_url = Rails.application.routes.url_helpers
      #                   .auth_user_session_url(auth_token: auth_token)
      # end

    end
  end
end

Warden::Strategies.add(:sgid_authenticatable, Devise::Strategies::SgidAuthenticatable)

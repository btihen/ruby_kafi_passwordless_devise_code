# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  def new_token
    render :new_token, locals: {user: User.new}
  end

  def create_token
    user_params = params.require(:user).permit(:email)
    user = User.find_by(email: user_params[:email])

    if user.present?
      user_sgid = user.to_sgid(expires_in: 1.hour, for: 'user_auth')
      auth_token= user_sgid.to_s
      auth_url = Rails.application.routes.url_helpers
                      .auth_user_session_url(auth_token: auth_token)
      UserAuthMailer.send_link(user, auth_url).deliver_later
    end
    flash[:notice] = "Please check your email for the access link"
    redirect_to root_path
  end

  # GET /user/token_auth
  def auth_token
    auth_token = params[:auth_token]
    user = GlobalID::Locator.locate_signed(auth_token, for: 'user_auth')
    if user.present?
      sign_in(user)
      flash[:notice] = "Welcome back! #{user.email}"
      redirect_to home_path
    else
      flash[:alert] = 'OOPS - something went wrong.'
      redirect_to root_path
    end
  end

  def logout_token
    sign_out(current_user)
    redirect_to root_path
  end

  # # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def gererate_auth_url(user, time_to_live, usage)
    user_sgid = user.to_sgid(expires_in: time_to_live, for: usage)
    auth_token= user_sgid.to_s
    auth_url = Rails.application.routes.url_helpers
                    .auth_user_session_url(auth_token: auth_token)
  end

end

# class Users::SessionsController < Devise::SessionsController
#   # before_action :configure_sign_in_params, only: [:create]

#   # GET /resource/sign_in
#   # def new
#   #   super
#   # end

#   # POST /resource/sign_in
#   # def create
#   #   super
#   # end

#   # DELETE /resource/sign_out
#   # def destroy
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_in_params
#   #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
#   # end
# end

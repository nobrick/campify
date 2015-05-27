class Uni::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def wechat
    if uni_user_signed_in?
      # [feature request] Bind wechat account to an existing user
    end

    auth = request.env['omniauth.auth']
    @user = User.find_by_omniauth(auth)
    if @user
      session[WECHAT_SESSION_KEY] = nil
      sign_in_and_redirect @user, :event => :authentication # This will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => '微信') if is_navigational_format?
    else
      session[WECHAT_SESSION_KEY] = auth
      if wechat_session_set?
        redirect_to new_uni_user_registration_url
      else
        redirect_to_failure_path
      end
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/wechat/callback
  def failure
    redirect_to_failure_path
  end

  private

  def redirect_to_failure_path
    redirect_to home_index_path, alert: '获取您的微信资料失败，请稍后重试'
  end

  # protected

  # The path used when omniauth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end

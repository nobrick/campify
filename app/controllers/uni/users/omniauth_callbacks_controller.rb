class Uni::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def wechat
    auth = request.env['omniauth.auth']
    @user = User.find_by_omniauth(auth)
    if @user
      sign_in_and_redirect @user, :event => :authentication # This will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => 'Wechat') if is_navigational_format?
    else
      session['devise.wechat_data'] = auth
      redirect_to new_uni_user_registration_url
    end
  end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when omniauth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end

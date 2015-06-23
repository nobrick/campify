class Uni::Users::RegistrationsController < Devise::RegistrationsController
  before_filter :authorize_wechat, only: [ :new ]
  before_filter :configure_sign_up_params, only: [ :create ]
  before_filter :configure_account_update_params, only: [ :update ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    t_user = nil
    super do |user|
      if wechat_session_set?
        auth = session[WECHAT_SESSION_KEY]
        user.uid = auth['uid']
        user.provider = auth['provider'] # wechat
        # user.password = Devise.friendly_token[0,20]
        info = auth['info']
        user.gender = case info['sex']
                      when 1 then 'male'
                      when 2 then 'female'
                      else nil
                      end
        user.province = info['province']
        user.city = info['city']
        user.country = info['country']
        user.wechat_headimgurl = info['headimgurl']
      end
      t_user = user
    end
    session.delete WECHAT_SESSION_KEY if t_user.persisted?
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    session[WECHAT_SESSION_KEY] = nil
    super
  end

  # protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) << :username << :email << :bio << :nickname << :university_id
  end

  # You can put the params you want to permit in the empty array.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) << :bio << :nickname << :university_id
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

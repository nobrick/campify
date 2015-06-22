class Uni::Users::SessionsController < Devise::SessionsController
  before_filter :authorize_wechat, only: [ :new ]
  before_filter :finish_wechat_sign_up, only: [ :new ]
# before_filter :configure_sign_in_params, only: [ :create ]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def after_sign_out_path_for(resource_or_scope)
    # request.referrer || root_path
    root_path
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :wechat_request?

  def wechat_request?
    request.env['HTTP_USER_AGENT'].include?(' MicroMessenger/')
  end

  def authorize_wechat
    # Redirect to omniauth and get callback for we-requests with no session set
    if wechat_request? && session[WECHAT_SESSION_KEY].nil?
      redirect_to uni_user_omniauth_authorize_path(:wechat)
    end
  end

  def finish_wechat_sign_up
    if wechat_request? && session[WECHAT_SESSION_KEY]
      redirect_to new_uni_user_registration_url
    end
  end
end

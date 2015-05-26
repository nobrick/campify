class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :wechat_request?, :enrolled_in?, :enrollment_for

  def enrolled_in?(showtime)
    uni_user_signed_in? && Enrollment.exists?(user_id: current_uni_user.id, showtime_id: showtime.id)
  end

  def enrollment_for(showtime)
    Enrollment.find_by(user_id: current_uni_user.id, showtime_id: showtime.id)
  end

  def authenticate_admin
    unless uni_user_signed_in? && current_uni_user.admin?
      redirect_to home_index_path, notice: '请以管理员身份登录。'
    end
  end

  def wechat_request?
    request.env['HTTP_USER_AGENT'].include?(' MicroMessenger/')
  end

  def authorize_wechat
    # Redirect to omniauth and get callback for we-requests with no session set.
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

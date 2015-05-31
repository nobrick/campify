class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :wechat_request?, :wechat_session_set?, :enrolled_in?, :enrollment_for
  helper_method :render_op_links?, :render_flash?
  helper_method :enable_render_flash, :disable_render_flash
  helper_method :enable_render_op_links, :disable_render_op_links

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

  def authorize_wechat
    # Redirect to omniauth and get callback for we-requests with no session set.
    if wechat_request? && !(wechat_session_set?)
      redirect_to uni_user_omniauth_authorize_path(:wechat)
    end
  end

  def finish_wechat_sign_up
    if wechat_request? && wechat_session_set?
      redirect_to new_uni_user_registration_url
    end
  end

  def wechat_session_set?
    value = session[WECHAT_SESSION_KEY]
    value.present? && value['extra']['raw_info'].present?
  end

  def wechat_request?
    request.env['HTTP_USER_AGENT'].include?(' MicroMessenger/')
  end

  private

  def render_op_links?
    @to_render_op_links && current_uni_user.try(:admin?) && !wechat_request?
  end

  def render_flash?
    @to_render_flash = true if @to_render_flash.nil?
    @to_render_flash
  end

  def enable_render_op_links
    @to_render_op_links = true
  end

  def disable_render_op_links
    @to_render_op_links = false
  end

  def enable_render_flash
    @to_render_flash = true
  end

  def disable_render_flash
    @to_render_flash = false
  end
end

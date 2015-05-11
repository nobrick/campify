module Uni::Users::RegistrationsHelper
  def registration_title
    if session['devise.wechat_data']
      '完善资料并完成注册'
    else
      '注册'
    end
  end
end

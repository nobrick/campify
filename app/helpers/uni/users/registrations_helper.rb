module Uni::Users::RegistrationsHelper
  def registration_title
    if wechat_request?
      '完善资料并完成注册'
    else
      '注册'
    end
  end
end

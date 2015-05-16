module Wechat::TestHelpers
  def set_wechat_environment(options = {})
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:wechat] = mock_wechat_auth(options)

    # Set env variables for controller
    # Use Rails.application.env_config instead of request.env for newew versions of RSpec 
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:uni_user]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:wechat]

    allow_any_instance_of(ApplicationController).to receive(:wechat_request?).and_return(true)
  end

  def mock_wechat_auth(options_new = {})
    options = {
      open_id: 'wkGVJuEIFWoUsSXq3ciCZUuPGYqM',
      nickname: '曲',
      city: 'Dalian',
      province: 'Liaoning',
      country: 'CN',
      headimgurl: 'http://wx.qlogo.cn/mmopen/FiaFiavradFnqG1q3ZS8m5icyTmu0PAwp3icRanfAnI1jQXEtPe6kMFalibCLY6fxRLqm1iaz1dxupuB3utchAK2jgruBgvD04xs4A/0',
      refresh_token: 'OezXcEiiBSKSxW0eoylIeL8yPl_5eXoofGVB8lY8TDXzZoinSk',
      token: 'OezXcEiiBSKSxW0eoylIeL8yPl_5eXoofGVB8lY8TDXzZoinSk',
      language: 'en'
    }
    options.merge!(options_new)

    OmniAuth::AuthHash.new({
      provider: 'wechat',
      uid: options[:open_id],
      credentials: {
        expires: true,
        expires_at: 1431499572,
        refresh_token: options[:refresh_token],
        token: options[:token]
      },
      extra: {
        raw_info: {
          city: options[:city], country: options[:country], headimgurl: options[:headimgurl],
          language: options[:language], nickname: options[:nickname], openid: options[:open_id],
          privilege: [], province: options[:province], sex: 1
        }
      },
      info: {
        city: options[:city], country: options[:country], headimgurl: options[:headimgurl],
        nickname: options[:nickname], province: options[:province], sex: 1
      }
    })
  end
end

RSpec.configure do |config|
  config.include Wechat::TestHelpers
end

require 'rails_helper'
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist

RSpec.feature 'Wechat omniauth', js: false do
  given(:nickname) { 'John Doe' }

  context 'Wechat omniauth failure' do
    before { set_wechat_environment(nickname: nickname, failure: true) }

    background do
      visit_wechat_omniauth
    end

    scenario 'show omniauth failure message' do
      expect_page_to_be_wechat_failure
    end
  end

  context 'Wechat omniauth success' do
    before { set_wechat_environment(nickname: nickname) }

    context 'To bind wechat by visiting omniauth page' do
      background do
        visit_wechat_omniauth
      end

      scenario 'get wechat sign-up page finally' do
        expect_page_to_be_wechat_sign_up
      end

      scenario 'autofill sign-up fields from wechat user info' do
        expect(page.find('#uni_user_username').value).to be_present
        expect(page.find('#uni_user_nickname').value).to eq nickname
      end

      scenario 'fill up info and bind wechat account' do
        fill_in_and_sign_up
        expect_signed_in
      end
    end

    context 'Before binding wechat' do
      scenario 'get wechat sign-up page by visiting sign-up page' do
        visit new_uni_user_registration_path
        expect_page_to_be_wechat_sign_up
      end

      scenario 'get wechat sign-up page by visiting sign-in page' do
        visit new_uni_user_session_path
        expect_page_to_be_wechat_sign_up
      end
    end

    context 'After binding wechat' do
      background do
        visit_wechat_omniauth
        fill_in_and_sign_up
        click_on '注销'
      end

      scenario 'sign out by clicking sign-out link' do
        expect_signed_out
      end

      scenario 'auto sign in by visiting wechat omniauth page' do
        visit_wechat_omniauth
        expect_signed_in
      end

      scenario 'auto sign in by visiting sign-up page' do
        visit new_uni_user_registration_path
        expect_signed_in
      end

      scenario 'auto sign in by visiting sign-in page' do
        visit new_uni_user_session_path
        expect_signed_in
      end
    end
  end

  def visit_wechat_omniauth
    visit uni_user_omniauth_authorize_path(:wechat)
  end

  def fill_in_and_sign_up
    fill_in 'Email', with: 'johndoe@example.com'
    fill_in '密码', with: '123456'
    fill_in '密码确认', with: '123456'
    click_button '完善资料并完成注册'
  end

  def expect_page_to_be_wechat_sign_up
    expect(page).to have_content '完善资料并完成注册'
  end

  def expect_page_to_be_wechat_failure
    expect(page).to have_content '获取您的微信资料失败'
  end

  def expect_signed_out
    expect(page).to have_content '登录'
  end

  def expect_signed_in(nickname = 'John Doe')
    expect(page).to have_content "Hi, #{nickname}"
  end
end

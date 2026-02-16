require 'test_helper'

class Member::SiteConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    @site_config = site_configs(:one)
    sign_in @userauth
  end

  test 'index画面を取得できる（認証あり）' do
    get member_site_configs_path, headers: basic_auth_header
    assert_response :success
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    get member_site_configs_path
    assert_redirected_to new_userauth_session_path
  end

  private

  def basic_auth_header
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      ENV['DIGEST_USER'] || 'test',
      ENV['DIGEST_PASS'] || 'test'
    )
    { 'HTTP_AUTHORIZATION' => credentials }
  end
end

require 'test_helper'

class Member::MagazinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    sign_in @userauth
  end

  test 'index画面を取得できる' do
    get member_magazines_path
    assert_response :success
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    get member_magazines_path
    assert_redirected_to new_userauth_session_path
  end
end

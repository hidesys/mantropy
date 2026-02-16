require 'test_helper'

class Member::Series::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    @serie = series(:one)
    sign_in @userauth
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    patch member_serie_post_path(@serie)
    assert_redirected_to new_userauth_session_path
  end
end

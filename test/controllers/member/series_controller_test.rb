require 'test_helper'

class Member::SeriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    @serie = series(:one)
    sign_in @userauth
  end

  test 'index画面を取得できる' do
    get member_series_index_path
    assert_response :success
  end

  test 'new画面を取得できる' do
    get new_member_series_path
    assert_response :success
  end

  test 'edit画面を取得できる' do
    get edit_member_series_path(@serie)
    assert_response :success
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    get member_series_index_path
    assert_redirected_to new_userauth_session_path
  end
end

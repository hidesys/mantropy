require 'test_helper'

class Member::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    @post = posts(:one)
    sign_in @userauth
  end

  test 'index画面を取得できる' do
    get member_posts_path
    assert_response :success
  end

  test 'show画面を取得できる' do
    get member_post_path(@post)
    assert_response :success
  end

  test 'new画面を取得できる' do
    get new_member_post_path
    assert_response :success
  end

  test 'edit画面を取得できる' do
    get edit_member_post_path(@post)
    assert_response :success
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    get member_posts_path
    assert_redirected_to new_userauth_session_path
  end
end

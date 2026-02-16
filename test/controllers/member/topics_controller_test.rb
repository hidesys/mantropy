require 'test_helper'

class Member::TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @userauth = userauths(:one)
    @topic = topics(:one)
    sign_in @userauth
  end

  test 'index画面を取得できる' do
    get member_topics_path
    assert_response :success
  end

  test 'new画面を取得できる' do
    get new_member_topic_path
    assert_response :success
  end

  test 'edit画面を取得できる' do
    get edit_member_topic_path(@topic)
    assert_response :success
  end

  test 'ログインしていない場合はログイン画面にリダイレクトされる' do
    sign_out @userauth
    get member_topics_path
    assert_redirected_to new_userauth_session_path
  end
end

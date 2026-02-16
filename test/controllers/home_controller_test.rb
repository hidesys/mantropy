require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'トップ画面を取得できる' do
    get root_path
    assert_response :success
  end

  test 'robots.txtを取得できる' do
    get robots_path(format: :text)
    assert_response :success
  end
end

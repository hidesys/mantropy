require 'test_helper'

class RankingsControllerTest < ActionDispatch::IntegrationTest
  test 'ランキング一覧画面を取得できる' do
    get rankings_path
    assert_response :success
  end
end

require 'test_helper'

class SeriesControllerTest < ActionDispatch::IntegrationTest
  test '検索ワードがない場合はリダイレクトされる' do
    get series_path
    assert_redirected_to root_path
  end

  test '検索ワードを指定して検索できる' do
    get series_path, params: { str: 'test' }
    assert_response :success
  end

  test 'シリーズ詳細画面を取得できる' do
    serie = series(:one)
    get "/series/#{serie.id}"
    assert_response :success
  end
end

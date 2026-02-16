require 'test_helper'

class Rankings::SeriesControllerTest < ActionDispatch::IntegrationTest
  test 'ランキング別シリーズ一覧画面を取得できる' do
    ranking = rankings(:one)
    get ranking_series_path(ranking)
    assert_response :success
  end

  test 'ランキング別集計済みシリーズ一覧画面を取得できる' do
    ranking = rankings(:one)
    get aggregated_ranking_series_path(ranking)
    assert_response :success
  end
end

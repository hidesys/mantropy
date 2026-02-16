require 'test_helper'

class Rankings::SeriesControllerTest < ActionDispatch::IntegrationTest
  test 'ランキング別シリーズ一覧画面はkindが未設定の場合aggregatedにリダイレクトされる' do
    ranking = rankings(:one)
    get ranking_series_path(ranking)
    assert_response :redirect
    assert_redirected_to aggregated_ranking_series_path(ranking.name)
  end

  test 'ランキング別集計済みシリーズ一覧画面を取得できる' do
    ranking = rankings(:one)
    get aggregated_ranking_series_path(ranking)
    assert_response :success
  end
end

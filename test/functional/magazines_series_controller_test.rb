require 'test_helper'

class MagazinesSeriesControllerTest < ActionController::TestCase
  setup do
    @magazines_serie = magazines_series(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:magazines_series)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create magazines_serie" do
    assert_difference('MagazinesSerie.count') do
      post :create, magazines_serie: { placed: @magazines_serie.placed }
    end

    assert_redirected_to magazines_serie_path(assigns(:magazines_serie))
  end

  test "should show magazines_serie" do
    get :show, id: @magazines_serie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @magazines_serie
    assert_response :success
  end

  test "should update magazines_serie" do
    put :update, id: @magazines_serie, magazines_serie: { placed: @magazines_serie.placed }
    assert_redirected_to magazines_serie_path(assigns(:magazines_serie))
  end

  test "should destroy magazines_serie" do
    assert_difference('MagazinesSerie.count', -1) do
      delete :destroy, id: @magazines_serie
    end

    assert_redirected_to magazines_series_path
  end
end

require 'test_helper'

class BrowsenodeidsControllerTest < ActionController::TestCase
  setup do
    @browsenodeid = browsenodeids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:browsenodeids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create browsenodeid" do
    assert_difference('Browsenodeid.count') do
      post :create, :browsenodeid => @browsenodeid.attributes
    end

    assert_redirected_to browsenodeid_path(assigns(:browsenodeid))
  end

  test "should show browsenodeid" do
    get :show, :id => @browsenodeid.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @browsenodeid.to_param
    assert_response :success
  end

  test "should update browsenodeid" do
    put :update, :id => @browsenodeid.to_param, :browsenodeid => @browsenodeid.attributes
    assert_redirected_to browsenodeid_path(assigns(:browsenodeid))
  end

  test "should destroy browsenodeid" do
    assert_difference('Browsenodeid.count', -1) do
      delete :destroy, :id => @browsenodeid.to_param
    end

    assert_redirected_to browsenodeids_path
  end
end

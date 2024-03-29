require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    @book = books(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:books)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create book' do
    assert_difference('Book.count') do
      post :create, book: @book.attributes
    end

    assert_redirected_to member_book_path(assigns(:book))
  end

  test 'should show book' do
    get :show, id: @book.to_param
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @book.to_param
    assert_response :success
  end

  test 'should update book' do
    put :update, id: @book.to_param, book: @book.attributes
    assert_redirected_to member_book_path(assigns(:book))
  end

  test 'should destroy book' do
    assert_difference('Book.count', -1) do
      delete :destroy, id: @book.to_param
    end

    assert_redirected_to member_books_path
  end
end

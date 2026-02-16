require 'test_helper'

class WikisControllerTest < ActionDispatch::IntegrationTest
  test '存在しないWikiページの場合はリダイレクトされる' do
    get wiki_path(name: 'nonexistent_wiki')
    assert_redirected_to root_path
  end
end

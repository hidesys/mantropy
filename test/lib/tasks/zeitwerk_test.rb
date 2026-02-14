require 'test_helper'

class ZeitwerkTest < ActionDispatch::IntegrationTest
  def setup
    rake_load_tasks
  end

  test 'zeitwerk が成功する' do
    assert_nothing_raised do
      Rake::Task['zeitwerk:check'].invoke
    end
  end
end

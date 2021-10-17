class Member::Base < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    authenticate_userauth!
  end
  
  def admin_basic_authentication
    authenticate_or_request_with_http_basic('Development Authentication') do |user, password|
      user == ENV['DIGEST_USER'] && password == ENV['DIGEST_PASS']
    end
  end
end

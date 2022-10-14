class Member::Base < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    authenticate_userauth!
    redirect_to new_member_user_path, notice: 'ユーザー情報を登録してください' if current_user.nil?
  end

  def admin_basic_authentication
    authenticate_or_request_with_http_basic('Development Authentication') do |user, password|
      user == ENV['DIGEST_USER'] && password == ENV['DIGEST_PASS']
    end
  end
end

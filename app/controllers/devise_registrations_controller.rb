# coding: utf-8
class DeviseRegistrationsController < Devise::RegistrationsController
  before_action :basic_authentication

  protected
  def after_sign_up_path_for(resource)
    new_user_path
  end

  def basic_authentication
   authenticate_or_request_with_http_basic("登録ページ表示用認証") do |user, password|
    user == DIGEST_USER && password == DIGEST_PASS
   end
  end
end

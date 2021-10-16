class Member::Base < ApplicationController
  before_action :authenticate_user!

  private

  def authenticate_user!
    authenticate_userauth!
  end
end

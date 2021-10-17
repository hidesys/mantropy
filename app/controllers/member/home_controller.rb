# encoding: UTF-8
class Member::HomeController < Member::Base
  def index
    @wiki = Wiki.where(name: 'logged_in').order("created_at DESC").limit(1).first
    @wikis = Wiki.where(name: @wiki&.name).order("created_at DESC")
  end
end

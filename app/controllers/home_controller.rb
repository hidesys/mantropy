class HomeController < ApplicationController
  def index
  end

  def robots
    respond_to do |format|
      format.txt
    end
  end
end

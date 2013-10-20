class RankingsController < ApplicationController
  before_filter :admin_basic_authentication

  def index
    @rankings = Ranking.all
    @new_ranking = Ranking.new
  end

  def show
    @ranking = Ranking.find(params[:id])
  end

  def create
    @ranking = Ranking.new(params[:ranking])
    if @ranking.save
      redirect_to rankings_path
    else
      redirect_to rankings_path
    end
  end

  def update
    @ranking = Ranking.find(params[:id])
    if @ranking.update_attributes(params[:ranking])
      redirect_to rankings_path
    else
      redirect_to rankings_path
    end
  end
end

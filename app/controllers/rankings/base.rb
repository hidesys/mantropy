class Rankings::Base < ApplicationController
  before_action :set_ranking

  private

  def set_ranking
    @ranking = Ranking.find_by(id: params[:ranking_id]) || Ranking.find_by(name: params[:ranking_id])

    redirect_to(rankings_path, notice: 'ランキングが存在しません') if @ranking.nil?
  end
end

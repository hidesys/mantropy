class RankingsController < ApplicationController
  def index
    @rankings = Ranking.order(id: :desc)
  end
end

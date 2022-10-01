class Member::RankingsController < Member::Base
  before_action :admin_basic_authentication

  def index
    @rankings = Ranking.order(:name)
    @new_ranking = Ranking.new
  end

  def show
    @ranking = Ranking.find(params[:id])
  end

  def create
    @ranking = Ranking.new(ranking_params)
    redirect_to member_rankings_path
  end

  def update
    @ranking = Ranking.find(params[:id])
    redirect_to member_rankings_path
  end

  private

  def ranking_params
    params.require(:ranking).permit(
      :name,
      :is_registerable,
      :scope_min,
      :scope_max,
      :kind
    )
  end
end

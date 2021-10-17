class Member::RankingsController < Member::Base
  before_action :admin_basic_authentication

  def index
    @rankings = Ranking.all
    @new_ranking = Ranking.new
    @site_configs = SiteConfig.all
  end

  def show
    @ranking = Ranking.find(params[:id])
  end

  def create
    @ranking = Ranking.new(ranking_params)
    if @ranking.save
      redirect_to rankings_path
    else
      redirect_to rankings_path
    end
  end

  def update
    @ranking = Ranking.find(params[:id])
    if @ranking.update_attributes(ranking_params)
      redirect_to rankings_path
    else
      redirect_to rankings_path
    end
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

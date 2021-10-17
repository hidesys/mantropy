class Member::RankingsController < Member::Base
  before_action :admin_basic_authentication

  def index
    @rankings = Ranking.order(:name)
    @new_ranking = Ranking.new
    @site_configs = SiteConfig.all
  end

  def show
    @ranking = Ranking.find(params[:id])
  end

  def create
    @ranking = Ranking.new(ranking_params)
    if @ranking.save
    end
    redirect_to rankings_path
  end

  def update
    @ranking = Ranking.find(params[:id])
    if @ranking.update_attributes(ranking_params)
    end
    redirect_to rankings_path
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

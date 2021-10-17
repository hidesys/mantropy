class Member::SiteConfigsController < Member::Base
  before_action :admin_basic_authentication

  def index
    @site_configs = SiteConfig.order(:path)
  end

  def create
    @site_config = SiteConfig.new(site_config_params)
    @site_config.save!
    redirect_to member_site_configs_path, notice: '当該の設定が追加されました'
  end

  def destroy
    @site_config = SiteConfig.find(params[:id])
    @site_config.destroy!
    redirect_to member_site_configs_path, notice: '当該の設定は削除されました'
  end

  def update
    @site_config = SiteConfig.find(params[:id])
    @site_config.update!(site_config_params)
    redirect_to member_site_configs_path, notice: '当該の設定が変更されました'
  end

  private

  def site_config_params
    params.require(:site_config).permit(:path, :name, :value)
  end
end

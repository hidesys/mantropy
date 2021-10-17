class Member::SiteConfigsController < Member::Base
  def create
    @site_config = SiteConfig.new(site_config_params)
    @site_config.save!
    redirect_to rankings_path, notice: "当該の設定が追加されました"
  end

  def destroy
    @site_config = SiteConfig.find(params[:id])
    @site_config.destroy!
    redirect_to rankings_path, notice: "当該の設定は削除されました"
  end


  def update
    @site_config = SiteConfig.find(params[:id])
    @site_config.update_attributes!(site_config_params)
    redirect_to rankings_path, notice: "当該の設定が変更されました"
  end

  private
  def site_config_params
    params.require(:site_config).permit(:path, :name, :value)
  end
end

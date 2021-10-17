class Member::Series::Base < Member::Base
  before_action :set_serie

  private

  def set_serie
    @serie = Serie.find(params[:serie_id])
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :complete_ranking, :serie_path

  private

  def complete_ranking(ranking, user = current_user)
    user && user.ranks.where(ranking_id: ranking.id).map do |r|
      (r.serie ? r.rank : 0)
    end.sort == ((ranking.scope_min)..(ranking.scope_max)).to_a
  end

  def current_user
    current_userauth ? current_userauth.user : nil
  end

  def after_sign_in_path_for(_resource)
    member_path
  end

  def serie_path(serie, *args)
    if serie.instance_of?(Serie) && args.length.zero?
      clean_serie_name(serie)
    else
      serie_url(serie, *args)
    end
  end

  def clean_serie_name(serie)
    base_name = "#{serie.name}-#{serie.authors&.map(&:name)&.join(',')}"[0..31].gsub(/[\.\/\\\+\s\"\'\{\}\[\]\*\,\;\:]/, '')
    "/#{CGI.escape(base_name)}/series/#{serie.id}"
  end

  def render_with_encoding(*options)
    if options[-1].is_a?(Hash) && (encoding = options[-1][:encoding])
      headers['Content-Disposition'] = 'Content-Disposition: attachment;'
      headers['Content-Type'] = "text/csv; charset=#{encoding}"
      render_without_encoding text: render_to_string.encode(encoding, invalid: :replace, undef: :replace)
    end
  end
  # alias_method_chain :render, :encoding

  def registerable_rankings
    Ranking.where(is_registerable: true)
  end

  def registering_rankings
    if registerable_rankings.empty?
      []
    else
      Ranking.where(['name LIKE ?',
                     "#{registerable_rankings.last.name[0...4]}%"]).order(:id)
    end
  end
end

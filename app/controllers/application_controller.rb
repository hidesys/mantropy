class ApplicationController < ActionController::Base
  before_action :development_basic_authentication
  protect_from_forgery

  helper_method :current_user, :complete_ranking, :serie_path

  private

  def admin_basic_authentication
    authenticate_or_request_with_http_basic("Development Authentication") do |user, password|
      user == ENV['DIGEST_USER'] && password == ENV['DIGEST_PASS']
    end
  end

  def development_basic_authentication
    if Rails.env == "development" then
      authenticate_or_request_with_http_basic("Development Authentication") do |user, password|
        user == ENV['DIGEST_USER'] && password == ENV['DIGEST_PASS']
      end
    else
      return true
    end
  end

  def complete_ranking(ranking, user = current_user)
    user && user.ranks.where(:ranking_id => ranking.id).map{|r| (r.serie ? r.rank : 0)}.sort == ((ranking.scope_min)..(ranking.scope_max)).to_a
  end

  def current_user
    current_userauth ? current_userauth.user : nil
  end

  def after_sign_in_path_for(resource)
    wiki_path(:name => "logged_in")
  end

  def serie_path(serie, *args)
    if serie.class == Serie && args.length == 0
      clean_serie_name(serie)
    else
      serie_url(serie, *args)
    end
  end

  def clean_serie_name(serie)
    URI.encode("/#{"#{serie.name.gsub(/[\/\?\.\#\!]/, "-")}-#{serie.authors.map{|a| a.name.gsub(/[\/\?\.\#\!]/, "-")}.join(",") if serie.authors}"[0..31]}/series/#{serie.id}")
  end

  def render_with_encoding(*options)
    if options[-1].is_a?(Hash) && (encoding = options[-1][:encoding])
      headers["Content-Disposition"] = "Content-Disposition: attachment;"
      headers["Content-Type"] = "text/csv; charset=#{encoding}"
      render_without_encoding :text => render_to_string.encode(encoding, :invalid => :replace, :undef => :replace)
    end
  end
  #alias_method_chain :render, :encoding

  def registerable_rankings
    Ranking.where(is_registerable: true)
  end

  def registering_rankings
    registerable_rankings.empty? ? [] : Ranking.where(["name LIKE ?", "#{registerable_rankings.last.name[0...4]}%"]).order(:id)
  end
end

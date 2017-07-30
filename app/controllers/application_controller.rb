class ApplicationController < ActionController::Base
  before_action :development_basic_authentication
  protect_from_forgery

  helper_method :current_user, :complete_ranking, :serie_path

  def authenticate_user!
    authenticate_userauth!
  end

  def admin_basic_authentication
    authenticate_or_request_with_http_basic("Development Authentication") do |user, password|
      user == DIGEST_USER && password == DIGEST_PASS
    end
  end

  def development_basic_authentication
    if Rails.env == "development" then
      authenticate_or_request_with_http_basic("Development Authentication") do |user, password|
        user == DIGEST_USER && password == DIGEST_PASS
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
      "/#{"#{serie.name.gsub(/[\/\?\.\#\!]/, "-")}-#{serie.authors.map{|a| a.name.gsub(/[\/\?\.\#\!]/, "-")}.join(",") if serie.authors}"[0..31]}/series/#{serie.id}"
    else
      serie_url(serie, *args)
    end
  end

  def bitly(long_url)
    id = 'o_17fv4v63h'
    api_key = 'R_4475cd7b5701dd47efb6645ed63355b1'
    version = '2.0.1'

    long_url = "http://mantropy.net" + long_url unless /http\:\/\// =~ long_url

    query = "version=#{version}&longUrl=#{long_url}&login=#{id}&apiKey=#{api_key}"
    result = JSON.parse(Net::HTTP.get("api.bit.ly", "/shorten?#{query}"))
    result['results'].each_pair {|long_url, value|
      return value['shortUrl']
    }
  end

  def irc_write(str, url = nil)
    Thread.new do
      telnet = Net::Telnet.new("Host" => "localhost", "Port" => 6660)
      telnet.puts("NICK mantropy")
      telnet.puts("USER mantropy 0 * :mantropy")
      telnet.write("NOTICE #mantropy@kyoto_u:*.jp :<#{current_user.name}> #{(s = str.gsub(/[\r\n]/, "")).size <= 42 ? s : s[0..40] + "..."} #{url ? bitly(url) : nil}\n")
      telnet.puts("QUIT")
    end
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
    Ranking.where(is_registerable: 1)
  end

  def registering_rankings
    registerable_rankings.empty? ? [] : Ranking.where(["name LIKE ?", "#{registerable_rankings.last.name[0...4]}%"]).order(:id)
  end
end

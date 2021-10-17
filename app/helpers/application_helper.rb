module ApplicationHelper
  def width
    800
  end

  def align
    'left'
  end

  def title
    "#{@title} #{Rails.env == 'development' ? '！！！！開発環境モード！！！！' : nil}"
  end

  def login(param = nil)
    param.to_s
  end

  def serie_to_amazon_url(serie)
    serie = serie.books.order('publicationdate DESC').first
    if serie&.detailurl
      serie.detailurl.gsub(/kumantropy-22/, 'mantropy-22').gsub(/mantropy-22/,
                                                                'kumantropy-22')
    else
      '/'
    end
  end
end

module SeriesHelper
  def serie_image_path(serie, size = :medium)
    rtn = nil

    serie.books.each do |book|
      rtn = book.smallimgurl if size == :small
      rtn = book.mediumimgurl if size == :medium
      rtn = book.largeimgurl if size == :large
      break if rtn
    end
    unless rtn
      rtn = 'nil_small.jpg' if size == :small
      rtn = 'nil_medium.jpg' if size == :medium
      rtn = 'nil_large.jpg' if size == :large
    end

    rtn
  end
end

module SeriesHelper
  def serie_image_path(s, size = :medium)
    rtn = nil

    s.books.each do |b|
      rtn = b.smallimgurl if size == :small
      rtn = b.mediumimgurl if size == :medium
      rtn = b.largeimgurl if size == :large
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

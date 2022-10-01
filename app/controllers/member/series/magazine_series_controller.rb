class Member::Series::MagazineSeriesController < Member::Series::Base
  def update
    case params[:mode]
    when 'remove'
      @serie.magazines_series.delete(MagazinesSerie.find(params[:magazines_serie_id]))
    when 'add'
      magazine_name = params[:magazine_name].strip
      if !magazine_name.empty? && Magazine.find_by_name(magazine_name).nil?
        magazine = Magazine.new
        magazine.name = magazine_name
        magazine.publisher = @serie.books.first && @serie.books.first.publisher
      else
        magazine = Magazine.find_by_name(magazine_name) || Magazine.find_by_id(params[:magazine_id])
      end
      placed = params[:magazine_placed].strip
      if @serie.magazines_series.where(magazine_id: magazine.id, placed:).empty?
        ms = MagazinesSerie.new
        ms.magazine = magazine
        ms.placed = placed
        ms.serie = @serie
        ms.save!
      end
    end
    redirect_to edit_member_serie_path(@serie)
  end
end

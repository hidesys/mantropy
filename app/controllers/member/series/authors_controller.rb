class Member::Series::AuthorsController < Member::Series::Base
  def update
    case params[:mode]
    when 'remove'
      @serie.authors_series.where(author_id: params[:author_id]).destroy_all
    when 'add'
      aa = Aaaws.normalize_author(params[:author_name])
      a = Author.find_by(name: aa)
      unless a
        a = Author.new
        a.name = aa
        a.save!
      end
      @serie.authors << a
    end
    redirect_to serie_path(@serie)
  end
end

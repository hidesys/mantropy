class Member::Series::AuthorsController < Member::Series::Base
  def update
    if params[:mode] == "remove" then
      @serie.authors_series.where(:author_id => params[:author_id]).destroy_all
    elsif params[:mode] == "add"
      unless a = Author.find_by_name(aa = Aaaws::normalize_author(params[:author_name]))
        a = Author.new
        a.name = aa
        a.save!
      end
      @serie.authors << a
    end
    redirect_to serie_path(@serie)
  end
end

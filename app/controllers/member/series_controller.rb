class Member::SeriesController < Member::Base
  @title = 'シリーズ'

  def index
    @title = 'シリーズ一覧'
    @series = Serie.order('id DESC').page(params[:page])
  end

  def new
    @serie = (params[:id] ? Serie.find(params[:id]) : Serie.new)
    @serie_new = params[:id] || true
  end

  def edit
    @serie = Serie.find(params[:id])
    @rankings = Ranking.where(is_registerable: true)
  end

  def create
    @serie = Serie.new(serie_params)

    unless a = Author.find_by_id(params[:author_id]) || Author.find_by_name(params[:author_name].strip)
      a = Author.new
      a.name = params[:author_name].strip
      a.save!
    end
    @serie.authors << a

    unless m = Magazine.find_by_id(params[:magazine_id]) || Magazine.find_by_name(params[:magazine_name].strip)
      m = Magazine.new
      m.name = params[:magazine_name].strip
      m.publisher = params[:magazine_publisher].strip
      m.save!
    end
    @serie.magazines << m if m

    params[:book_ids]&.each do |bid|
      @serie.books << Book.find(bid)
    end

    if @serie.save
      redirect_to(serie_path(@serie), notice: 'Serie was successfully created.')
    else
      render action: 'new'
    end
  end

  def update
    @serie = Serie.find(params[:id])

    if @serie.update_attributes(serie_params)
      redirect_to(@serie, notice: 'Serie was successfully updated.')
    else
      render action: 'edit'
    end
  end

  def destroy
    @serie = Serie.find(params[:id])
    @serie.destroy

    redirect_to(series_url)
  end

  # 不要疑惑
  def remove_duplications
    order_by = (params[:order_by] ? params[:order_by].gsub(/_/, '.') : nil) || 'authors.name'
    @series = Serie.select(
      'DISTINCT series.*'
    ).includes(
      :ranks, :authors
    ).where(
      ranks: { ranking_id: params[:ranking_id] }
    ).order(
      order_by
    ).page(
      params[:page]
    ).per(1000)
  end

  private

  def serie_params
    params.require(:serie).permit(
      :author_name,
      :magazine_name,
      :name
    )
  end
end

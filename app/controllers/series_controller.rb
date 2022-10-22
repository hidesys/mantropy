class SeriesController < ApplicationController
  @title = 'シリーズ'

  def index
    @str = params[:str]
    @title = "#{@str} の検索結果"
    if @str.blank?
      redirect_to root_path, notice: '検索ワードを指定してください'
      return
    end

    if params[:scope] =~ /^rakuten/ && current_user
      begin
        RakutenSearchService.search_and_store(@str)
      rescue StandardError => e
        flash.now[:alert] = e
        raise e if Rails.env.development?
      end
    end

    search_strs = @str.strip.split(/[\s　]/).map { |s| "%#{s}%" }
    serie_arel = Serie.arel_table[:name].matches_all(search_strs)
    authors = Author.where(Author.arel_table[:name].matches_all(search_strs))
    unless authors.empty?
      author_serie_ids = authors.map { |a| a.authors_series.map(&:serie_id) }.flatten
      serie_arel = serie_arel.or(Serie.arel_table[:id].in_any(author_serie_ids))
    end
    @series = Kaminari.paginate_array(Serie.where(serie_arel).uniq).page(params[:page])

    if @series.length == 1
      redirect_to serie_path(@series[0])
    else
      render 'index'
    end
  end

  def show
    @serie = Serie.find(params[:id])
    @title = "#{@serie.name} のシリーズ情報"
    # @similar_series = Serie.find_by_sql("SELECT s.* FROM series s INNER JOIN (SELECT r1.serie_id, COUNT(*) AS similarity FROM ranks r1 INNER JOIN ranks r2 ON r1.user_id=r2.user_id WHERE r2.serie_id=#{@serie.id} GROUP BY r1.serie_id ORDER BY similarity DESC, SUM(r1.score) DESC) r ON r.serie_id=s.id WHERE s.id!=#{@serie.id} LIMIT 4")
    # @ranks = @serie.ranks.where(:ranking_id => [1, 2, 3, 4]).order("ranking_id DESC, rank")
    @ranks = @serie.ranks.where(ranking_id: Ranking.where('is_registerable IS NULL OR is_registerable = FALSE')).order('ranking_id DESC, rank')

    unless @serie.topic
      topic = Topic.new
      topic.save!
      @serie.topic = topic
      @serie.save!
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @serie }
    end
  end
end

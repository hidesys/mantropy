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

    # サーチワードを空白で分割してor検索
    search_strs = @str.strip.split(/[\s　]/)

    series = Serie.all
    search_strs.each.with_index do |s, i|
      series = if i.zero?
        series.where("name LIKE ?", "%#{s}%") :
        else
          series.or(scope.where("name_kana LIKE ?", "%#{s}%"))
        end
    end

    authors = Author.all
    search_strs.each.with_index do |s, i|
      authors = if i.zero?
          authors.where("name LIKE ?", "%#{s}%") :
        else
          authors.or(scope.where("name_kana LIKE ?", "%#{s}%"))
        end
    end

    # 著者名で引っかかるときはその著者のシリーズも含めて表示
    if authors.exists?
      serie_ids = AuthorSerie.where(author_id: authors.pluck(:id)).pluck(:serie_id)
      series = series.or(Serie.where(id: serie_ids))
    end
    @series = series.page(params[:page])

    if @series.one?
      # 結果が1件の場合はそのシリーズの詳細ページにリダイレクト
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

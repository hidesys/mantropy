# encoding: UTF-8
class SeriesController < ApplicationController
  @title = "シリーズ"

  def ranking
    @title = "全体ランキング"
    ranking = Ranking.find_by_name(params[:str]) || Ranking.find(params[:str])
    ranking_id = ranking ? ranking.id : 5

    @series = Kaminari.paginate_array(Serie.find_by_sql("SELECT s.* FROM series s INNER JOIN ranks r ON s.id=r.serie_id WHERE r.ranking_id=#{ranking_id} ORDER BY r.rank")).page(params[:page])

    respond_to do |format|
      format.html # ranking.html.erb
      format.txt  { render :txt => @series }
    end
  end

  def ranking_now
    @title = "全体ランキング"

    ranking = Ranking.find_by_name(params[:str]) || Ranking.find_by_id(params[:str]) || Ranking.where('kind = "kojin" AND (is_registerable IS NULL OR is_registerable = TRUE)').last
    ranking_plus = ranking_minus = nil
    if ranking.kind == "kojin"
      ranking_plus = ranking
      ranking_minus = Ranking.where(["name LIKE ? AND kind = ?", "#{ranking.name[0...4]}%", "kuso"]).last
    else ranking.kind == "kuso"
      ranking_plus = Ranking.where(["name LIKE ? AND kind = ?", "#{ranking.name[0...4]}%", "kojin"]).last
      ranking_minus = ranking
    end
    share_with = SiteConfig.config('ranking_now_share_with')
    share_with_members = share_with == 'members'
    share_with_no_one = share_with == 'no_one'
    if !share_with_no_one && (!share_with_members || current_user)
      sql = "SELECT s.id, s.name, s.topic_id, s.post_id, " +
        "'合計得点: '||rs.mark||'　糞補正後得点: '||(rs.mark + COALESCE(rk.mark,0))||'　重複数: '||(COALESCE(rs.count,0))||'　糞重複数: '||(COALESCE(rk.count, 0))||'　コメント数: '||COALESCE(pc.countp, 0)||'　最高順位: '||rs.min_rank AS url, " +
        "(rs.mark + COALESCE(rk.mark,0)) AS amark " +
        "FROM series s " +
        "INNER JOIN (" +
        "SELECT (SUM(#{ranking_plus.scope_max + 1} - rank) + ((COUNT(*) - 1) * 3)) AS mark, serie_id, count(id) AS count, MIN(rank) AS min_rank FROM ranks WHERE ranking_id=#{ranking_plus.id} GROUP BY serie_id" +
        ") rs ON s.id=rs.serie_id " +
        "LEFT JOIN (" +
        "SELECT (SUM(rank - #{ranking_minus.scope_max + 1}) * 2 + (COUNT(*) -1) * (-3)) AS mark, serie_id, count(id) AS count FROM ranks WHERE ranking_id=#{ranking_minus.id} GROUP BY serie_id" +
        ") rk ON s.id = rk.serie_id " +
        "LEFT JOIN (" +
        "SELECT COUNT(p.id) AS countp, p.topic_id FROM posts p WHERE p.created_at > (SELECT created_at FROM rankings WHERE id=#{ranking_plus.id}) GROUP BY p.topic_id" +
        ") pc ON s.topic_id=pc.topic_id"
      if ranking == ranking_plus
        sql += " order by rs.mark DESC, rs.count DESC, rs.min_rank, rk.count"
      else ranking == ranking_minus
        sql += " order by amark DESC, rs.count DESC, rs.min_rank, rk.count"
      end

      @ranking_ids = [ranking_plus.id, ranking_minus.id]
      @series = Serie.find_by_sql(sql)
      @series.map! do |serie|
        if /^合計得点\:\s(\d+)　糞補正後得点\:\s(\-?\d+)　重複数\:\s(\d+)　糞重複数\:\s(\d+)　コメント数\:\s(\d+)　最高順位\:\s(\d+)$/ =~ serie.url
          serie.rank_info = {sum_of_mark: $1, sum_of_mark_with_kuso: $2, count_rank: $3, count_kuso: $4, count_post: $5, min_rank: $6}
        end
        serie
      end
      if ranking == ranking_plus
        rank = rank_ = sum_of_mark = count_rank = min_rank = 0
        @series.map! do |serie|
          rank_ += 1
          if !(serie.rank_info[:sum_of_mark] == sum_of_mark && serie.rank_info[:count_rank] == count_rank && serie.rank_info[:min_rank] == min_rank)
            rank = rank_
          end
          sum_of_mark = serie.rank_info[:sum_of_mark]
          count_rank = serie.rank_info[:count_rank]
          min_rank = serie.rank_info[:min_rank]
          serie.rank_info[:rank] = rank
          serie
        end
      else ranking == ranking_minus
        rank = rank_ = sum_of_mark_with_kuso = count_kuso = min_rank = 0
        @series.map! do |serie|
          rank_ += 1
          if !(serie.rank_info[:sum_of_mark_with_kuso] == sum_of_mark_with_kuso && serie.rank_info[:count_kuso] == count_kuso && serie.rank_info[:min_rank] == min_rank)
            rank = rank_
          end
          sum_of_mark_with_kuso = serie.rank_info[:sum_of_mark_with_kuso]
          count_kuso = serie.rank_info[:count_kuso]
          min_rank = serie.rank_info[:min_rank]
          serie.rank_info[:rank] = rank
          serie
        end
      end
      @is_should_comment_term = !ranking_plus.is_registerable && !ranking_minus.is_registerable

      @series = Kaminari.paginate_array(@series).page(params[:page]).per(64)

      respond_to do |format|
        format.html# { render html: (@series = Kaminari.paginate_array(@series).page(params[:page]).per(64)) }
        format.csv#  { render :content_type => 'text/csv' }
        format.xml  { @series = @series[0..55] }
        format.json { @series = @series[0..55] }
      end
    else
      if share_with_no_one
        redirect_to root_path, :notice => "ランキングは集計中なので誰も見れないよ"
      else
        redirect_to root_path, :notice => "ランキングは集計中なのでメンバーだけが見れるよ"
      end
    end
  end

  def index
    str = params[:str]
    @title = "#{str} の検索結果"
    @str = str
    if str.blank?
      redirect_to root_path, notice: '検索ワードを指定してください'
      return
    end

    if params[:scope] =~ /^rakuten/ && current_user
      begin
        RakutenSearchService.search_and_store(str)
      rescue => error
        flash.now[:alert] = error
        raise error if Rails.env.development?
      end
    end

    search_strs = str.strip.split(/[\s　]/).map{|s| "%#{s}%"}
    serie_arel = Serie.arel_table[:name].matches_all(search_strs)
    authors = Author.where(Author.arel_table[:name].matches_all(search_strs))
    unless authors.empty?
      author_serie_ids = authors.map{|a| a.authors_series.map{|as| as.serie_id}}.flatten
      serie_arel = serie_arel.or(Serie.arel_table[:id].in_any(author_serie_ids))
    end
    @series = Kaminari.paginate_array(Serie.where(serie_arel).uniq).page(params[:page])

    if @series.length == 1
      redirect_to serie_path(@series[0])
    else
      render "index"
    end
  end

  def show
    @serie = Serie.find(params[:id])
    @title = "#{@serie.name} のシリーズ情報"
    #@similar_series = Serie.find_by_sql("SELECT s.* FROM series s INNER JOIN (SELECT r1.serie_id, COUNT(*) AS similarity FROM ranks r1 INNER JOIN ranks r2 ON r1.user_id=r2.user_id WHERE r2.serie_id=#{@serie.id} GROUP BY r1.serie_id ORDER BY similarity DESC, SUM(r1.score) DESC) r ON r.serie_id=s.id WHERE s.id!=#{@serie.id} LIMIT 4")
    #@ranks = @serie.ranks.where(:ranking_id => [1, 2, 3, 4]).order("ranking_id DESC, rank")
    @ranks = @serie.ranks.where(:ranking_id => Ranking.where("is_registerable IS NULL OR is_registerable = FALSE")).order("ranking_id DESC, rank")

    unless @serie.topic then
      topic = Topic.new
      topic.save!
      @serie.topic = topic
      @serie.save!
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @serie }
    end
  end
end

class Rankings::SeriesController < Rankings::Base
  def index
    @title = '全体ランキング'

    ranking_plus = ranking_minus = nil
    case @ranking.kind
    when 'kojin'
      ranking_plus = @ranking
      ranking_minus = Ranking.where(['name LIKE ? AND kind = ?', "#{@ranking.name[0...4]}%", 'kuso']).last
    when 'kuso'
      ranking_plus = Ranking.where(['name LIKE ? AND kind = ?', "#{@ranking.name[0...4]}%", 'kojin']).last
      ranking_minus = @ranking
    else
      return redirect_to(aggregated_ranking_series_path(ranking.name))
    end

    share_with = SiteConfig.config('ranking_now_share_with')
    return redirect_to(rankings_path, notice: 'ランキングは集計中なので誰も見れないよ') if share_with == 'no_one'
    if share_with == 'members' && current_user.blank?
      return redirect_to(rankings_path, notice: 'ランキングは集計中なのでメンバーだけが見れるよ')
    end

    sql = 'SELECT s.id, s.name, s.topic_id, s.post_id, ' \
          "'合計得点: '||rs.mark||'　糞補正後得点: '||(rs.mark + COALESCE(rk.mark,0))||'　重複数: '||(COALESCE(rs.count,0))||'　糞重複数: '||(COALESCE(rk.count, 0))||'　コメント数: '||COALESCE(pc.countp, 0)||'　最高順位: '||rs.min_rank AS url, " \
          '(rs.mark + COALESCE(rk.mark,0)) AS amark ' \
          'FROM series s ' \
          'INNER JOIN (' \
          "SELECT (SUM(#{ranking_plus.scope_max + 1} - rank) + ((COUNT(*) - 1) * 3)) AS mark, serie_id, count(id) AS count, MIN(rank) AS min_rank FROM ranks WHERE ranking_id=#{ranking_plus.id} GROUP BY serie_id" \
          ') rs ON s.id=rs.serie_id ' \
          'LEFT JOIN (' \
          "SELECT (SUM(rank - #{ranking_minus.scope_max + 1}) * 2 + (COUNT(*) -1) * (-3)) AS mark, serie_id, count(id) AS count FROM ranks WHERE ranking_id=#{ranking_minus.id} GROUP BY serie_id" \
          ') rk ON s.id = rk.serie_id ' \
          'LEFT JOIN (' \
          "SELECT COUNT(p.id) AS countp, p.topic_id FROM posts p WHERE p.created_at > (SELECT created_at FROM rankings WHERE id=#{ranking_plus.id}) GROUP BY p.topic_id" \
          ') pc ON s.topic_id=pc.topic_id'
    if @ranking == ranking_plus
      sql += ' order by rs.mark DESC, rs.count DESC, rs.min_rank, rk.count'
    elsif @ranking == ranking_minus
      sql += ' order by amark DESC, rs.count DESC, rs.min_rank, rk.count'
    end

    @ranking_ids = [ranking_plus.id, ranking_minus.id]
    @series = Serie.find_by_sql(sql)
    @series.map! do |serie|
      if /^合計得点:\s(\d+)　糞補正後得点:\s(-?\d+)　重複数:\s(\d+)　糞重複数:\s(\d+)　コメント数:\s(\d+)　最高順位:\s(\d+)$/ =~ serie.url
        serie.rank_info = { sum_of_mark: Regexp.last_match(1), sum_of_mark_with_kuso: Regexp.last_match(2), count_rank: Regexp.last_match(3), count_kuso: Regexp.last_match(4),
                            count_post: Regexp.last_match(5), min_rank: Regexp.last_match(6) }
      end
      serie
    end
    if @ranking == ranking_plus
      rank = rank_ = sum_of_mark = count_rank = min_rank = 0
      @series.map! do |serie|
        rank_ += 1
        unless serie.rank_info[:sum_of_mark] == sum_of_mark && serie.rank_info[:count_rank] == count_rank && serie.rank_info[:min_rank] == min_rank
          rank = rank_
        end
        sum_of_mark = serie.rank_info[:sum_of_mark]
        count_rank = serie.rank_info[:count_rank]
        min_rank = serie.rank_info[:min_rank]
        serie.rank_info[:rank] = rank
        serie
      end
    elsif @ranking == ranking_minus
      rank = rank_ = sum_of_mark_with_kuso = count_kuso = min_rank = 0
      @series.map! do |serie|
        rank_ += 1
        unless serie.rank_info[:sum_of_mark_with_kuso] == sum_of_mark_with_kuso && serie.rank_info[:count_kuso] == count_kuso && serie.rank_info[:min_rank] == min_rank
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
      format.html # { render html: (@series = Kaminari.paginate_array(@series).page(params[:page]).per(64)) }
      format.csv #  { render :content_type => 'text/csv' }
      format.xml  { @series = @series[0..55] }
      format.json { @series = @series[0..55] }
    end
  end

  def aggregated
    @title = '全体ランキング'
    @series = Kaminari.paginate_array(Serie.find_by_sql("SELECT s.* FROM series s INNER JOIN ranks r ON s.id=r.serie_id WHERE r.ranking_id=#{@ranking.id} ORDER BY r.rank")).page(params[:page])
  end
end

# encoding: UTF-8
class SeriesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :search, :ranking, :ranking_now]
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

    #sql = "SELECT s.id, s.name, \"コメント数:\"||(COALESCE((SELECT COUNT(*) FROM topics t INNER JOIN posts p ON t.id = p.topic_id WHERE t.id = s.topic_id),0))||\"　純得点: \"||(rs.mark - (rs.count -1) * 3)||\"　補正後得点: \"||rs.mark||\"　重複数: \"||rs.count AS url FROM series s INNER JOIN (SELECT (SUM(31 - rank) + ((COUNT(*) - 1) * 3)) AS mark, serie_id, count(id) AS count from ranks where ranking_id=#{ranking_id} and rank between 1 and 30 group by serie_id) rs ON s.id=rs.serie_id order by rs.mark DESC, rs.count DESC"
    #ranking_id = (Ranking.find_by_name(params[:str]) ? Ranking.find_by_name(params[:str]).id : 1)
    #sql = "SELECT s.id, s.name, \"純得点: \"||(rs.mark - (rs.count -1) * 3)||\"　補正後得点: \"||rs.mark||\"　重複数: \"||rs.count AS url FROM series s INNER JOIN (SELECT (SUM(31 - rank) + ((COUNT(*) - 1) * 3)) AS mark, serie_id, count(id) AS count from ranks where ranking_id=#{ranking_id} and rank between 1 and 30 group by serie_id) rs ON s.id=rs.serie_id order by s.name"
    #@series = Kaminari.paginate_array(Serie.find_by_sql(sql)).page(params[:page])
    #render "ranking_name"
    #return

    ranking = Ranking.find_by_name(params[:str]) || Ranking.find(params[:str])
    ranking_id = ranking ? ranking.id : 5
    is_ranking_now = [1, 2, 5, 6].include? ranking_id
    if is_ranking_now
      ranking_id_plus = {1 => 1, 2 => 1, 5 => 5, 6 => 5}[ranking_id]
      ranking_id_minus = {1 => 2, 2 => 2, 5 => 6, 6 => 6}[ranking_id]
      sql = "SELECT s.id, s.name, s.topic_id, s.post_id, " +
        "\"合計得点: \"||rs.mark||\"　糞補正後得点: \"||(rs.mark + COALESCE(rk.mark,0))||\"　重複数: \"||(COALESCE(rs.count,0))||\"　糞重複数: \"||(COALESCE(rk.count, 0))||\"　コメント数: \"||COALESCE(pc.countp, 0)||\"　最高順位: \"||rs.min_rank AS url, " +
        "(rs.mark + COALESCE(rk.mark,0)) AS amark " +
        "FROM series s " +
        "INNER JOIN (" +
        "SELECT (SUM(31 - rank) + ((COUNT(*) - 1) * 3)) AS mark, serie_id, count(id) AS count, MIN(rank) AS min_rank FROM ranks WHERE ranking_id=#{ranking_id_plus} GROUP BY serie_id" +
        ") rs ON s.id=rs.serie_id " +
        "LEFT JOIN (" +
        "SELECT (SUM(rank - 6) * 2 + (COUNT(*) -1) * (-3)) AS mark, serie_id, count(id) AS count FROM ranks WHERE ranking_id=#{ranking_id_minus} GROUP BY serie_id" +
        ") rk ON s.id = rk.serie_id " +
        "LEFT JOIN (" +
        "SELECT COUNT(p.id) AS countp, p.topic_id FROM posts p WHERE p.created_at > (SELECT created_at FROM rankings WHERE id=#{ranking_id_plus}) GROUP BY p.topic_id" +
        ") pc ON s.topic_id=pc.topic_id"
      if ranking_id == ranking_id_plus
        sql += " order by rs.mark DESC, rs.count DESC, rs.min_rank, rk.count"
      else ranking_id == ranking_id_minus
        sql += " order by amark DESC, rs.count DESC, rs.min_rank, rk.count"
      end

      @ranking_ids = [ranking_id_plus, ranking_id_minus]
      @series = Serie.find_by_sql(sql)
      @series.map! do |serie|
        if /^合計得点\:\s(\d+)　糞補正後得点\:\s(\-?\d+)　重複数\:\s(\d+)　糞重複数\:\s(\d+)　コメント数\:\s(\d+)　最高順位\:\s(\d+)$/ =~ serie.url
          serie.url = {sum_of_mark: $1, sum_of_mark_with_kuso: $2, count_rank: $3, count_kuso: $4, count_post: $5, min_rank: $6}
        end
        serie
      end
      if ranking_id == ranking_id_plus
        rank = rank_ = sum_of_mark = count_rank = min_rank = 0
        @series.map! do |serie|
          rank_ += 1
          if !(serie.url[:sum_of_mark] == sum_of_mark && serie.url[:count_rank] == count_rank && serie.url[:min_rank] == min_rank)
            rank = rank_
          end
          sum_of_mark = serie.url[:sum_of_mark]
          count_rank = serie.url[:count_rank]
          min_rank = serie.url[:min_rank]
          serie.url[:rank] = rank
          serie
        end
      else ranking_id == ranking_id_minus
        rank = rank_ = sum_of_mark_with_kuso = count_kuso = min_rank = 0
        @series.map! do |serie|
          rank_ += 1
          if !(serie.url[:sum_of_mark_with_kuso] == sum_of_mark_with_kuso && serie.url[:count_kuso] == count_kuso && serie.url[:min_rank] == min_rank)
            rank = rank_
          end
          sum_of_mark_with_kuso = serie.url[:sum_of_mark_with_kuso]
          count_kuso = serie.url[:count_kuso]
          min_rank = serie.url[:min_rank]
          serie.url[:rank] = rank
          serie
        end
      end

      respond_to do |format|
        format.html { render :html => @series = Kaminari.paginate_array(@series).page(params[:page]).per(64) }
        format.csv  { render :csv => @series }
        format.txt  { render :txt => @series = @series[0..55] }
      end
    else
      redirect_to root_path
    end
  end

  def search
    str = params[:str]
    @title = "#{str} の検索結果"
    @str = str

    begin
     if params[:scope] == "amazon_all" && current_user
        aaawss = Aaaws.search(str, 4)
      elsif params[:scope] == "amazon" && current_user
        aaawss = Aaaws.search(str)
      elsif params[:scope] == "mantropy" && current_user
        aaawss = AaawsResponseArray.new
      else
        aaawss = AaawsResponseArray.new
      end
    rescue => evar
        if Rails.env == "development"
          raise evar
        end
        aaawss = AaawsResponseArray.new
    end

    aaawss.node_lists.each do |n|
      unless Browsenodeid.where(:node => n[0], :name => n[1], :ancestor => n[2]).exists?
        bn = Browsenodeid.new
        bn.node = n[0]
        bn.name = n[1]
        bn.ancestor = n[2]
        bn.save!
      end
    end

    aaawss.each do |a|
      Book.transaction() do
        unless b = Book.find_by_name(a.title)
          b = Book.new
          b.isbn = a.isbn
          b.name = a.title
          b.publisher = a.publisher
          b.publicationdate = a.publication_date
          b.kind = a.binding
          b.label = a.label
          b.asin = a.asin
          b.detailurl = a.detail_page_url
          b.smallimgurl = a.small_image
          b.mediumimgurl = a.medium_image
          b.largeimgurl = a.large_image
          b.iscomic = a.is_comic
          if a.is_comic
            nmlznm = Aaaws::normalize_title(a.title)
            a.browse_node_ids.each do |aa|
              bn = Browsenodeid.find_by_node(aa)
              if bn.id == 86142051 || a.binding == "雑誌"
                unless Magazine.find_by_name(nmlznm)
                  m = Magazine.new
                  m.name = nmlznm
                  m.publisher = a.publisher
                  m.save!
                end
              end
            end
            a.authors.each do |aa|
              nmlzau =  Aaaws::normalize_author(aa)
              unless au = Author.find_by_name(nmlzau)
                au = Author.new
                au.name = nmlzau
                au.save!
                aui = Authoridea.new
                aui.author = au
                aui.idea = au.id
                aui.save!
              end
              b.authors << au
            end
            unless s = Serie.find_by_name(nmlznm)
              t = Topic.new
              t.save!
              s = Serie.new
              s.name = nmlznm
              s.topic = t
              s.authors << b.authors
              s.save!
            end
            b.series << s
          end
          b.save!
        end
      end
    end

    #q = ["SELECT DISTINCT s.* FROM series s LEFT JOIN books_series bs ON s.id = bs.serie_id LEFT JOIN books b ON b.id = bs.book_id LEFT JOIN authors_series as0 ON s.id = as0.serie_id LEFT JOIN authors aa ON as0.author_id = aa.id LEFT JOIN authorideas ai0 ON aa.id = ai0.author_id LEFT JOIN authorideas ai1 ON ai0.idea = ai1.idea LEFT JOIN authors a ON ai1.author_id = a.id WHERE 0<>0 OR "]
    #str.strip.split(/[\s　]/).each do |s|
    #  q[0] += " (s.name LIKE ? OR b.name LIKE ? OR a.name LIKE ?) AND"
    #  q += Array.new(3){"%#{s}%"}
    #end
    #q[0] = q[0][0..(q[0].length - 4)] + " ORDER BY s.id"
    #@series = Kaminari.paginate_array(Serie.find_by_sql(q)).page(params[:page])
    search_strs = str.strip.split(/[\s　]/).map{|s| "%#{s}%"}
    @series = Kaminari.paginate_array((
      Serie.where(
        Serie.arel_table[:name].matches_any(search_strs).or(
          Serie.arel_table[:id].in_any(
            Author.where(
              Author.arel_table[:name].matches_any(search_strs)
            ).map{|a| a.authors_series.map{|as| as.serie_id}}.flatten
          )
        )
      )
    ).uniq).page(params[:page])

    if @series.length == 1
      redirect_to serie_path(@series[0])
    else
      render "index"
    end
  end

  # GET /series
  # GET /series.xml
  def index
    @title = "シリーズ一覧"
    @series = Serie.order("id DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @series }
    end
  end

  # GET /series/1
  # GET /series/1.xml
  def show
    @serie = Serie.find(params[:id])
    @title = "#{@serie.name} のシリーズ情報"
    #@similar_series = Serie.find_by_sql("SELECT s.* FROM series s INNER JOIN (SELECT r1.serie_id, COUNT(*) AS similarity FROM ranks r1 INNER JOIN ranks r2 ON r1.user_id=r2.user_id WHERE r2.serie_id=#{@serie.id} GROUP BY r1.serie_id ORDER BY similarity DESC, SUM(r1.score) DESC) r ON r.serie_id=s.id WHERE s.id!=#{@serie.id} LIMIT 4")
    #@ranks = @serie.ranks.where(:ranking_id => [1, 2, 3, 4]).order("ranking_id DESC, rank")
    @ranks = @serie.ranks.where(:ranking_id => Ranking.where("is_registerable IS NULL")).order("ranking_id DESC, rank")

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

  # GET /series/new
  # GET /series/new.xml
  def new
    @serie = (params[:id] ? Serie.find(params[:id]) : Serie.new)
    @serie_new = params[:id] || true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @serie }
    end
  end

  # GET /series/1/edit
  def edit
    @serie = Serie.find(params[:id])
    @rankings = Ranking.where(:is_registerable => 1)

    ma = @serie.magazine_ids.uniq.clone
    @serie.magazines.clear
    ma.each do |mi|
      @serie.magazines << Magazine.find(mi)
    end
  end

  # POST /series
  # POST /series.xml
  def create
    @serie = Serie.new(params[:serie])

    unless a = Author.find_by_id(params[:author_id]) || Author.find_by_name(params[:author_name].strip)
      a = Author.new
      a.name = params[:author_name].strip
      a.save!
    end
    @serie.authors << a

    unless  m = Magazine.find_by_id(params[:magazine_id]) || Magazine.find_by_name(params[:magazine_name].strip)
      m = Magazine.new
      m.name = params[:magazine_name].strip
      m.publisher = params[:magazine_publisher].strip
      m.save!
    end
    @serie.magazines << m if m

    if params[:book_ids]
      params[:book_ids].each do |bid|
        @serie.books << Book.find(bid)
      end
    end

    respond_to do |format|
      if @serie.save
        format.html { redirect_to(root_path, :notice => 'Serie was successfully created.') }
        format.xml  { render :xml => @serie, :status => :created, :location => @serie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @serie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /series/1
  # PUT /series/1.xml
  def update
    @serie = Serie.find(params[:id])

    respond_to do |format|
      if @serie.update_attributes(params[:serie])
        format.html { redirect_to(@serie, :notice => 'Serie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @serie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.xml
  def destroy
    @serie = Serie.find(params[:id])
    @serie.destroy

    respond_to do |format|
      format.html { redirect_to(series_url) }
      format.xml  { head :ok }
    end
  end

  def update_author
    @serie = Serie.find(params[:id])
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
    redirect_to @serie
  end

  def update_magazine
    @serie = Serie.find(params[:id])
    if params[:mode] == "remove" then
      @serie.magazines.delete(Magazine.find params[:magazine_id])
    elsif params[:mode] == "add"
      m = Magazine.find_by_id(params[:magazine_id])
      @serie.magazines << m if m && !(@serie.magazines.include?(m))
    end
    redirect_to @serie
  end

  def update_post
    Post.transaction do
      @serie = Serie.find(params[:id])
      post = Post.new(params[:post])
      post.user = current_user
      post.order = Post.where(:topic_id => post.topic_id).count + 1
      post.save!
      unless /sage/ =~ params[:post][:email] then
        @serie.topic.updated_at = Time.now
        @serie.topic.save!
      end
      @serie.post = post
      @serie.save!
    end

    redirect_to @serie
  end

  def remove_duplications
    order_by = (params[:order_by] ? params[:order_by].gsub(/\_/, ".") : nil) || "authors.name"
    @series = Serie.select("DISTINCT series.*").includes(:ranks, :authors).where(ranks: {ranking_id: params[:ranking_id]}).order(order_by).page(params[:page]).per(1000)
  end
end

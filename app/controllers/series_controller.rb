# encoding: UTF-8
class SeriesController < ApplicationController
  @title = "シリーズ"

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
    rescue
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

    q = ["SELECT DISTINCT s.* FROM series s LEFT JOIN books_series bs ON s.id = bs.serie_id LEFT JOIN books b ON b.id = bs.book_id LEFT JOIN authors_series as0 ON s.id = as0.serie_id LEFT JOIN authors aa ON as0.author_id = aa.id LEFT JOIN authorideas ai0 ON aa.id = ai0.author_id LEFT JOIN authorideas ai1 ON ai0.idea = ai1.idea LEFT JOIN authors a ON ai1.author_id = a.id WHERE"]
    str.split(/(\s|　)/).each do |s|
      q[0] += " s.name LIKE ? OR b.name LIKE ? OR a.name LIKE ? OR"
      q += Array.new(3){"%#{str}%"}
    end
    q[0] = q[0][0..(q[0].length - 3)]
    @series = Serie.find_by_sql(q)

    render "index"
  end

  # GET /series
  # GET /series.xml
  def index
    @series = Serie.all

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
    @rank = Rank.new
    @rankings = Ranking.all

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
  end

  # POST /series
  # POST /series.xml
  def create
    @serie = Serie.new(params[:serie])

    a = Author.find_by_id(params[:author_id])
    unless (a = Author.find_by_id(params[:author_id])) || params[:author_name].strip == "" || a = Author.find_by_name(params[:author_name].strip)
      a = Author.new
      a.name = params[:author_name].strip
      a.save!
    end
    @serie.authors << a

    unless  (m = Magazine.find_by_id(params[:magazine_id])) || params[:magazine_name].strip == "" || m = Magazine.find_by_name(params[:magazine_name].strip)
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
        format.html { redirect_to(@serie, :notice => 'Serie was successfully created.') }
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
end

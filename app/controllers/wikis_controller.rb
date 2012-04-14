# coding: UTF-8
class WikisController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  # GET /wikis
  # GET /wikis.xml
  def index
    @wikis = Kaminari.paginate_array(Wiki.find_by_sql("SELECT w.* FROM wikis w INNER JOIN (SELECT MAX(created_at) created_at, name FROM wikis GROUP BY name) w1 ON w.created_at=w1.created_at AND w.name=w1.name ORDER BY created_at DESC")).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wikis }
    end
  end

  # GET /wikis/1
  # GET /wikis/1.xml
  def show
    @wiki = Wiki.where(id: params[:id]).order("created_at DESC").limit(1)
    if @wiki.empty?
      @wiki = Wiki.where(name: params[:name]).order("created_at DESC").limit(1)[0]
    else
      @wiki = @wiki[0]
    end
    if @wiki == nil then
      redirect_to root_path, :alreat => "該当するページがありません"
    elsif ! current_user && Wiki.where(name: @wiki.name, created_at: Wiki.where(name: @wiki.name).maximum(:created_at))[0].is_private
      redirect_to root_path, :alreat => "おちんちん舐めいたよぅ"
    else
      @wikis = Wiki.where(name: @wiki.name).order("created_at DESC")
      @title = @wiki.title
      @content = HikiDoc.to_html(@wiki.content, :use_wiki_name=>false)

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @wiki }
      end
    end
  end

  # GET /wikis/new
  # GET /wikis/new.xml
  def new
    wiki = Wiki.find_by_id(params[:id])
    if wiki then
      @wiki = Wiki.new(name: wiki.name, title: wiki.title, content: wiki.content, is_private: wiki.is_private)
    else
      @wiki = Wiki.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wiki }
    end
  end

  # GET /wikis/1/edit
  def edit
    @wiki = Wiki.find(params[:id])
  end

  # POST /wikis
  # POST /wikis.xml
  def create
    @wiki = Wiki.new(params[:wiki])
    @wiki.user = current_user
    @wiki.is_private = @wiki.is_private && @wiki.is_private != 0 ? 1 : nil

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to(@wiki, :notice => 'Wiki was successfully created.') }
        format.xml  { render :xml => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wikis/1
  # PUT /wikis/1.xml
  def update
    @wiki = Wiki.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(params[:wiki])
        format.html { redirect_to(@wiki, :notice => 'Wiki was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.xml
  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy

    respond_to do |format|
      format.html { redirect_to(wikis_url) }
      format.xml  { head :ok }
    end
  end
end

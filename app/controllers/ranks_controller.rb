# encoding: UTF-8
class RanksController < ApplicationController
  before_filter :authenticate_user!

  # GET /ranks
  # GET /ranks.xml
  def index
    @ranks = Rank.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ranks }
    end
  end

  # GET /ranks/1
  # GET /ranks/1.xml
  def show
    @rank = Rank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rank }
    end
  end

  # GET /ranks/new
  # GET /ranks/new.xml
  def new
    @rank = Rank.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rank }
    end
  end

  # GET /ranks/1/edit
  def edit
    @rank = Rank.find(params[:id])
  end

  # POST /ranks
  # POST /ranks.xml
  def create
    params[:rank][:rank].tr!("０-９", "0-9")
    @rank = Rank.new(params[:rank])
    @rank.user_id = current_user.id

    if params[:magazine_name].strip != "" && Magazine.find_by_name(params[:magazine_name].strip) == nil
      m = Magazine.new
      m.name = params[:magazine_name].strip
      s = Serie.find(@rank.serie_id)
      m.publisher = s.books.first.publisher unless s.books.empty?
      m.series << s
      m.save
    elsif params[:magazine_id] != ""
      s = Serie.find(@rank.serie_id)
      s.magazines << Magazine.find(params[:magazine_id])
      s.save
    end

    if complete_ranking(1) && params[:rank][:ranking_id] == "1" then
      redirect_to(root_path, :notice => "ランキングの変更はできません")
      return
    end

    msg = nil
    unless (r = Rank.where(:user_id => current_user.id, :rank => params[:rank][:rank])).empty?
      msg = "上書きしました。"
      @rank = r[0]
      @rank.serie_id = params[:rank][:serie_id]
    end

    respond_to do |format|
      if @rank.save
        format.html { redirect_to(user_path(current_user.name), :notice => "#{@rank.serie.name} に #{@rank.rank} 位を#{msg ? msg : "登録しました。"}") }
        format.xml  { render :xml => @rank.serie, :status => :created, :location => @rank.book }
      else
        format.html { redirect_to(@rank.serie, :notice => '失敗。ランク登録に合わない情報が混じった気がする') }
        format.xml  { render :xml => @rank.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ranks/1
  # PUT /ranks/1.xml
  def update
    @rank = Rank.find(params[:id])

    respond_to do |format|
      if @rank.update_attributes(params[:rank])
        format.html { redirect_to(@rank, :notice => 'Rank was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rank.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ranks/1
  # DELETE /ranks/1.xml
  def destroy
    @rank = Rank.find(params[:id])
    @rank.destroy if @rank.user_id == current_user.id

    respond_to do |format|
      format.html { redirect_to(user_path(current_user.name)) }
      format.xml  { head :ok }
    end
  end
end

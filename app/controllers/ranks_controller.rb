# encoding: UTF-8
class RanksController < ApplicationController
  before_action :authenticate_user!

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
    @rank = Rank.new(rank_params)
    @rank.user_id = current_user.id
    @rank.serie_id = params[:serie_id]
    @rank.ranking_id = params[:ranking_id]
    s = Serie.find(@rank.serie_id)

    magazine_name = params[:magazine_name].strip
    if !magazine_name.empty? && Magazine.find_by_name(magazine_name) == nil
      magazine = Magazine.new
      magazine.name = magazine_name
      magazine.publisher = s.books.first && s.books.first.publisher
    else
      magazine = Magazine.find_by_name(magazine_name) || Magazine.find_by_id(params[:magazine_id])
    end
    if magazine
      placed = params[:magazine_placed].strip
      if s.magazines_series.where(:magazine_id => magazine.id, :placed => placed).empty?
        ms = MagazinesSerie.new
        ms.magazine = magazine
        ms.placed = placed
        ms.serie = s
        ms.save!
      end
    end

    #complete_ranking(1)
    if !Ranking.find(params[:rank][:ranking_id]).is_registerable
      redirect_to(user_path(current_user.name), :notice => "ランキングの変更はできません")
      return
    end

    msg = nil
    if !((r = Rank.where(:user_id => current_user.id, :rank => rank_params[:rank], :ranking_id => rank_params[:ranking_id])).empty?)
      msg = "上書きしました。"
      @rank = r[0]
      @rank.serie_id = params[:serie_id]
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
      if @rank.update_attributes(rank_params)
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
    if @rank.user_id == current_user.id && @rank.ranking.is_registerable == 1
      @rank.destroy
      respond_to do |format|
        format.html { redirect_to(user_path(current_user.name)) }
        format.xml  { head :ok }
      end
    else
      redirect_to user_path(@rank.user.name), alert: "あなたはこのランキングデータのユーザーでないか、またはこのランキングデータは修正できないものです"
    end
  end

  private
  def rank_params
    params.require(:rank).permit(
      :rank,
      :score
    )
  end
end

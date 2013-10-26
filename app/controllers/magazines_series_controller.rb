class MagazinesSeriesController < ApplicationController
  # GET /magazines_series
  # GET /magazines_series.json
  def index
    @magazines_series = MagazinesSerie.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @magazines_series }
    end
  end

  # GET /magazines_series/1
  # GET /magazines_series/1.json
  def show
    @magazines_serie = MagazinesSerie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @magazines_serie }
    end
  end

  # GET /magazines_series/new
  # GET /magazines_series/new.json
  def new
    @magazines_serie = MagazinesSerie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @magazines_serie }
    end
  end

  # GET /magazines_series/1/edit
  def edit
    @magazines_serie = MagazinesSerie.find(params[:id])
  end

  # POST /magazines_series
  # POST /magazines_series.json
  def create
    @magazines_serie = MagazinesSerie.new(params[:magazines_serie])

    respond_to do |format|
      if @magazines_serie.save
        format.html { redirect_to @magazines_serie, notice: 'Magazines serie was successfully created.' }
        format.json { render json: @magazines_serie, status: :created, location: @magazines_serie }
      else
        format.html { render action: "new" }
        format.json { render json: @magazines_serie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /magazines_series/1
  # PUT /magazines_series/1.json
  def update
    @magazines_serie = MagazinesSerie.find(params[:id])

    respond_to do |format|
      if @magazines_serie.update_attributes(params[:magazines_serie])
        format.html { redirect_to @magazines_serie, notice: 'Magazines serie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @magazines_serie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazines_series/1
  # DELETE /magazines_series/1.json
  def destroy
    @magazines_serie = MagazinesSerie.find(params[:id])
    @magazines_serie.destroy

    respond_to do |format|
      format.html { redirect_to magazines_series_url }
      format.json { head :no_content }
    end
  end
end

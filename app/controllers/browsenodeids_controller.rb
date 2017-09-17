class BrowsenodeidsController < ApplicationController
  # GET /browsenodeids
  # GET /browsenodeids.xml
  def index
    @browsenodeids = Browsenodeid.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @browsenodeids }
    end
  end

  # GET /browsenodeids/1
  # GET /browsenodeids/1.xml
  def show
    @browsenodeid = Browsenodeid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @browsenodeid }
    end
  end

  # GET /browsenodeids/new
  # GET /browsenodeids/new.xml
  def new
    @browsenodeid = Browsenodeid.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @browsenodeid }
    end
  end

  # GET /browsenodeids/1/edit
  def edit
    @browsenodeid = Browsenodeid.find(params[:id])
  end

  # POST /browsenodeids
  # POST /browsenodeids.xml
  def create
    @browsenodeid = Browsenodeid.new(browsenodeid_params)

    respond_to do |format|
      if @browsenodeid.save
        format.html { redirect_to(@browsenodeid, :notice => 'Browsenodeid was successfully created.') }
        format.xml  { render :xml => @browsenodeid, :status => :created, :location => @browsenodeid }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @browsenodeid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /browsenodeids/1
  # PUT /browsenodeids/1.xml
  def update
    @browsenodeid = Browsenodeid.find(params[:id])

    respond_to do |format|
      if @browsenodeid.update_attributes(browsenodeid_params)
        format.html { redirect_to(@browsenodeid, :notice => 'Browsenodeid was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @browsenodeid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /browsenodeids/1
  # DELETE /browsenodeids/1.xml
  def destroy
    @browsenodeid = Browsenodeid.find(params[:id])
    @browsenodeid.destroy

    respond_to do |format|
      format.html { redirect_to(browsenodeids_url) }
      format.xml  { head :ok }
    end
  end

  private
  def browsenodeid_params
    params.require(:browsenodeid).permit(
      :node,
      :name,
      :ancestor
    )
  end
end

# encoding: UTF-8
class TopicsController < ApplicationController
  before_action :authenticate_user!
  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.where(:appear => 1).order("updated_at DESC, id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])

    if @topic.title == nil
      redirect_to serie_path(Serie.find_by_topic_id(@topic.id))
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @topic }
      end
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  def create
    post = Post.new
    begin
      Topic.transaction do
        @topic = Topic.new(topic_params)
        @topic.appear = 1
        raise if @topic.title == "" || @topic.title == nil
        @topic.save!

        post = Post.new
        post.content = params[:content]
        post.email = params[:email]
        post.user = current_user
        post.order = 1
        post.topic = @topic
        post.save!
      end
      irc_write("[#{@topic.title ? @topic.title : Serie.find_by_topic_id(@topic.id).name}] #{post.content}")
      redirect_to(topics_path, :notice => 'スレッド作成と書き込みに成功しました。')
    rescue
      redirect_to(topics_path, :alert => '何かおかしいで。')
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(topic_params)
        format.html { redirect_to(@topic, :notice => 'Topic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
  private
  def topic_params
    params.require(:topic).permit(
    :appear,
    :title
    )
  end
end

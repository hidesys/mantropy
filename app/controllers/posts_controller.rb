# encoding: UTF-8
class PostsController < ApplicationController
  before_filter :authenticate_user!
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    topic = @post.topic
    redirect_path = (topic.title ? topic : serie_path(Serie.find_by_topic_id(topic.id)))
    begin
      Post.transaction do
        @post.user = current_user
        @post.order = Post.where(:topic_id => @post.topic_id).count + 1
        @post.save!
        unless /sage/ =~ params[:post][:email] then
          topic.updated_at = Time.now
          topic.save!
        end
      end
      redirect_to(redirect_path, :notice => '書き込みに成功しました')
    rescue
      redirect_to(redirect_path, :notice => "何かがおかしい。")
    end
      irc_write("[#{(tt = topic.title) ? topic.title : (s = Serie.find_by_topic_id(topic.id)).name}] #{@post.content}", tt ? topic_path(topic) : serie_path(s))
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end

# encoding: UTF-8
class Member::TopicsController < Member::Base
  def index
    @topics = Topic.where(:appear => 1).order("updated_at DESC, id DESC")
  end

  def show
    @topic = Topic.find(params[:id])

    if @topic.title == nil
      return redirect_to serie_path(Serie.find_by_topic_id(@topic.id))
    end
  end

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
  end

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
      redirect_to(member_topics_path, :notice => 'スレッド作成と書き込みに成功しました。')
    rescue
      redirect_to(member_topics_path, :alert => '何かおかしいで。')
    end
  end

  def update
    @topic = Topic.find(params[:id])

    if @topic.update_attributes(topic_params)
      redirect_to(member_topic_path(@topic), :notice => 'Topic was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    redirect_to(member_topics_path)
  end

  private

  def topic_params
    params.require(:topic).permit(
    :appear,
    :title
    )
  end
end

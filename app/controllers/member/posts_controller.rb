class Member::PostsController < Member::Base
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.topic_id = params[:topic_id]
    topic = @post.topic
    redirect_path = (topic.title ? member_topic_path(topic) : serie_path(Serie.find_by(topic_id: topic.id)))
    begin
      Post.transaction do
        @post.user = current_user
        @post.order = Post.where(topic_id: @post.topic_id).count + 1
        @post.save!
        unless /sage/ =~ params[:post][:email]
          topic.updated_at = Time.zone.now
          topic.save!
        end
      end
      redirect_to(redirect_path, notice: '書き込みに成功しました')
    rescue StandardError
      redirect_to(redirect_path, notice: '何かがおかしい。')
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to(member_post_path(@post), notice: 'Post was successfully updated.')
    else
      render action: 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to(member_posts_path)
  end

  private

  def post_params
    params.require(:post).permit(
      :name,
      :email,
      :order,
      :content,
      :topic,
      :user
    )
  end
end

class Member::Series::PostsController < Member::Series::Base
  def update
    Post.transaction do
      post = Post.new(post_params)
      post.topic_id = params[:topic_id]
      post.user = current_user
      post.order = Post.where(:topic_id => post.topic_id).count + 1
      post.save!
      unless /sage/ =~ params[:post][:email] then
        @serie.topic.updated_at = Time.now
        @serie.topic.save!
      end
      @serie.post = post
      @serie.save!
    end

    redirect_to @serie
  end

  private

  def post_params
    params.require(:post).permit(
      :email,
      :content
    )
  end
end

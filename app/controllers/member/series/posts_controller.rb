class Member::Series::PostsController < Member::Series::Base
  def update
    Post.transaction do
      post = Post.new(post_params)
      post.topic_id = params[:topic_id]
      post.user = current_user
      post.order = Post.where(topic_id: post.topic_id).count + 1
      post.save!
      unless /sage/ =~ params[:post][:email]
        @serie.topic.updated_at = Time.zone.now
        @serie.topic.save!
      end
      @serie.post = post
      @serie.save!
    end

    redirect_to serie_path(@serie)
  end

  private

  def post_params
    params.expect(
      post: %i[email
               content]
    )
  end
end

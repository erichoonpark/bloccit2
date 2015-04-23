class PostsController < ApplicationController
  def show
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @topic = Topic.find(params[:topic_id])
    authorize @post
  end

  def create
    @topic = Topic.find(params[:topic_id])
    #@post = current_user.posts.build(post_params)
    @post = @topic.posts.build(post_params.merge(user_id: current_user.id))
    authorize @post
    if @post.save
      flash[:notice] = "Post was saved."
      redirect_to [@topic, @post]
    else
      flash[:notice] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    authorize @post
  end

  def update
    @topic = Topic.find(params[:topic_id])
    @post = Post.find(params[:id])
    authorize @post
    if @post.update_attributes(post_params)
      flash[:notice] = "Post was updated."
      redirect_to @topic
    else
      flash[:error] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end

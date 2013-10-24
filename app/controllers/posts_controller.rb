class PostsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    authorize! :participate, @project
    @post = @project.posts.new
  end

  def create
    @post = Post.new(post_params)
    authorize! :participate, @post.project
    @post.user_uuid = current_user.uuid
    if @post.save
      redirect_to project_path @post.project
    else
      render 'new'
    end
  end

private

  def post_params
    params.require(:post).permit(:title, :content, :project_id)
  end
end
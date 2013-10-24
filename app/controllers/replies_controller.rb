class RepliesController < ApplicationController 
  def new 
    post = Post.find(params[:post_id])
    @reply = post.replies.new
    authorize! :participate, post.project
  end

  def create 
    @reply = Reply.new(reply_params)
    authorize! :participate, @reply.post.project
    @reply.user_uuid = current_user.uuid
    if @reply.save 
      redirect_to project_path(@reply.post.project)
    else
      render 'new'
    end
  end

private
  def reply_params
    params.require(:reply).permit(:post_id, :content)
  end
end
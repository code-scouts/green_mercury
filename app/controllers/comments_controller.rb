class CommentsController < ApplicationController

  def new 
    project = Project.find(params[:project_id])
    authorize! :participate, project
    @comment = project.comments.new
  end

  def create 
    @comment = Comment.new(comment_params)
    authorize! :participate, @comment.commentable
    @comment.user_uuid = current_user.uuid
    if @comment.save 
      redirect_to project_path(@comment.commentable)
    else
      render 'new'
    end
  end

private
  def comment_params
    params.require(:comment).permit(:title, :comment, :commentable_id, :commentable_type)
  end
end
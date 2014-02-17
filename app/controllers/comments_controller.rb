class CommentsController < ApplicationController

  def new 
    parent = parent_model.find(params[:commentable_id]) 
    @comment = parent.comments.new
    authorize! :participate, @comment.get_project
  end

  def create 
    @comment = Comment.new(comment_params)
    authorize! :participate, @comment.get_project
    @comment.user_uuid = current_user.uuid
    if @comment.save 
      redirect_to project_path(@comment.get_project)
    else
      render 'new'
    end
  end

private
  def comment_params
    params.require(:comment).permit(:title, :comment, :commentable_id, :commentable_type)
  end

  def parent_model
    if params[:commentable_type] === 'Project'
      Project
    elsif params[:commentable_type] === 'Comment'
      Comment
    end
  end
end

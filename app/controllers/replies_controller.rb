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
      participants = (@reply.post.project.mentor_participations + @reply.post.project.member_participations).delete_if { |participation| participation.user_uuid.nil? }
      @users = associated_users(participants)

      respond_to do |format|
        format.html { redirect_to project_path @reply.post.project }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.js
      end
    end
  end

private
  def reply_params
    params.require(:reply).permit(:post_id, :content)
  end
end
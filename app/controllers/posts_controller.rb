class PostsController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    authorize! :participate, @project
    @post = @project.posts.new
  end

  def create
    @project = Project.find(params[:post][:project_id])
    @post = @project.posts.new(post_params)
    authorize! :participate, @project
    @post.user_uuid = current_user.uuid
    if @post.save
      participants = (@project.mentor_participations + @project.member_participations).delete_if { |participation| participation.user_uuid.nil? }
      @users = associated_users(participants)

      respond_to do |format|
        format.html { redirect_to project_path @project }
        format.js  
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.js { render 'new.js' }
      end
    end
  end

private

  def post_params
    params.require(:post).permit(:title, :content, :project_id)
  end
end
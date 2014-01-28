class ProjectsController < ApplicationController
  def index
    @user_projects = current_user.projects
    @available_projects = Project.available_for(current_user)
  end

  def new
    @project = Project.new
    authorize! :create, @project 
  end

  def create 
    @project = Project.new(project_params)
    authorize! :create, @project
    @project.user_uuid = current_user.uuid
    if @project.save
      redirect_to project_path(@project), notice: "Project successfully created!"
    else
      render 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize! :update, @project
  end

  def update 
    @project = Project.find(params[:id])
    authorize! :update, @project
    @project.update(project_params)
    redirect_to @project, notice: 'Changes saved!'
  end

  def show
    @project = Project.find(params[:id])
    participants = (@project.mentor_participations + @project.member_participations).delete_if { |participation| participation.user_uuid.nil? }
    @users = associated_users(participants)
  end

private 
  def project_params
    params.require(:project).permit(:title, :start_date, :end_date, :description, :image, :mentor_participations_attributes => [:id, :role], :member_participations_attributes => [:id, :role])
  end
end

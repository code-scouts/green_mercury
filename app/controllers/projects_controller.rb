class ProjectsController < ApplicationController
  def index
    @user_projects = current_user.projects
    if current_user.is_mentor?
      @available_projects = Project.available('mentor') - @user_projects
      @unavailable_projects = Project.unavailable('mentor') - @user_projects
    else
      @available_projects = Project.available('member') - @user_projects
      @unavailable_projects = Project.unavailable('member') - @user_projects
    end
  end

  def new
    @project = Project.new
    @project.mentor_participations.build
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
    params.require(:project).permit(:title, :start_date, :end_date, :description, :image, :mentor_participations_attributes => [:role], :member_participations_attributes => [:role])
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
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

  def show
    @project = Project.find(params[:id])
    participant_uuids = (@project.mentor_participations + @project.member_participations).delete_if { |participation| participation.user_uuid.nil? }
    @users = associated_users(participant_uuids)    
  end

private 
  def project_params
    params.require(:project).permit(:title, :start_date, :end_date, :description, :mentor_participations_attributes => [:role], :member_participations_attributes => [:role])
  end
end

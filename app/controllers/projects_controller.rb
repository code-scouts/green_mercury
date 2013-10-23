class ProjectsController < ApplicationController
  def index

  end

  def new
    @project = Project.new
    @participation = @project.participations.new
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

  end

private 
  def project_params
    params.require(:project).permit(:title, :start_date, :end_date, :description)
  end
end

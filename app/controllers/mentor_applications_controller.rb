class MentorApplicationsController < ApplicationController
  skip_before_filter :new_applicant?
  
  def new
    @mentor_application = MentorApplication.new(user_uuid: current_user.uuid)
  end

  def create
    @mentor_application = MentorApplication.new(mentor_application_params)
    if @mentor_application.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @application = MentorApplication.find(params[:id])
  end

private

  def mentor_application_params
    params.require(:mentor_application).permit(:content, :user_uuid)
  end
end
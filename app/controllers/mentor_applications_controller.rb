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
    params.require(:mentor_application).permit(:user_uuid, :name, :contact, :geography, :hear_about, :motivation, :time_commitment, :mentor_one_on_one, :mentor_group, :mentor_online, :volunteer_events, :volunteer_teams, :volunteer_solo, :volunteer_technical, :volunteer_online)
  end
end
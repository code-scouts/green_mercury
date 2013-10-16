class MentorApplicationsController < ApplicationController
  skip_before_filter :new_applicant, only: [:new, :create]
  
  def index 
    @pending_mentor_applications = MentorApplication.pending
  end

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
    if can? :read, @application
      render 'show'
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

  def update
    @application = MentorApplication.find(params[:id])
    if params[:approve]
      @application.approved_date = Date.today
      @application.approved = true
      @application.save
      flash[:notice] = "Application approved"
    end
    redirect_to member_applications_path
  end

private

  def mentor_application_params
    params.require(:mentor_application).permit(:user_uuid, 
                                               :name, 
                                               :contact, 
                                               :geography, 
                                               :hear_about, 
                                               :motivation, 
                                               :time_commitment, 
                                               :mentor_one_on_one, 
                                               :mentor_group, 
                                               :mentor_online, 
                                               :volunteer_events, 
                                               :volunteer_teams, 
                                               :volunteer_solo, 
                                               :volunteer_technical, 
                                               :volunteer_online)
  end
end
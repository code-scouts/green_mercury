class MentorApplicationsController < ApplicationController
  include ApplicantManager
  skip_before_filter :new_applicant, only: [:new, :create]

private
  def application_params
    if can? :update, MentorApplication.new
      params.require(:mentor_application).permit(:approved,
                                                 :user_uuid, 
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
    else
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

  def application_model
    MentorApplication
  end
end
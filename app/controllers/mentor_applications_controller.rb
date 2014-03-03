class MentorApplicationsController < ApplicationController
  include ApplicantManager
  skip_before_filter :new_applicant, only: [:new, :create]
  skip_before_filter :require_code_of_conduct, only: [:new, :create]

private
  def application_params
    if can? :update, MentorApplication.new
      params.require(:mentor_application).permit(:approved_date,  
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
                                                 :volunteer_online,
                                                 :rejected_date,
                                                 :rejected_by_user_uuid,
                                                 :accepted_by_user_uuid)
    else
      params.require(:mentor_application).permit( 
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
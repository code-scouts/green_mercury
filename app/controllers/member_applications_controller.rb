class MemberApplicationsController < ApplicationController
  include ApplicantManager
  skip_before_filter :new_applicant, only: [:new, :create]


private

  def application_params
    if can? :update, MemberApplication.new
      params.require(:member_application).permit(:name,
                                                 :approved, 
                                                 :why_you_want_to_join, 
                                                 :gender, 
                                                 :experience_level, 
                                                 :confidence_technical_skills, 
                                                 :basic_programming_knowledge, 
                                                 :comfortable_learning, 
                                                 :current_projects, 
                                                 :time_commitment, 
                                                 :hurdles, 
                                                 :excited_about, 
                                                 :anything_else, 
                                                 :user_uuid) 

    else
      params.require(:member_application).permit(:name, 
                                                 :why_you_want_to_join, 
                                                 :gender, 
                                                 :experience_level, 
                                                 :confidence_technical_skills, 
                                                 :basic_programming_knowledge, 
                                                 :comfortable_learning, 
                                                 :current_projects, 
                                                 :time_commitment, 
                                                 :hurdles, 
                                                 :excited_about, 
                                                 :anything_else, 
                                                 :user_uuid)
    end
  end

  def application_model
    MemberApplication
  end
end
class NewApplicationsController < ApplicationController
  skip_before_filter :new_applicant?
  def index 
    
  end

  def show
    if current_user.member_application
      @application = current_user.member_application
      redirect_to member_application_path(@application)
    else
      @application = current_user.mentor_application
      redirect_to mentor_application_path(@application)
    end
  end
end
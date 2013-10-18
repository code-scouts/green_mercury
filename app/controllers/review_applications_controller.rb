class ReviewApplicationsController < ApplicationController
  def index
    if can? :update, MentorApplication.new
      @member_applications = MemberApplication.pending
      @member_applicants = associated_users(@member_applications)
      @mentor_applications = MentorApplication.pending
      @mentor_applicants = associated_users(@mentor_applications)
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

end
class RejectedApplicationsController < ApplicationController
  def index
    if can? :update, MentorApplication.new
      @mentor_applications = MentorApplication.rejected
      @mentor_applicants = associated_users(@mentor_applications)
      @member_applications = MemberApplication.rejected
      @member_applicants = associated_users(@member_applications)
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
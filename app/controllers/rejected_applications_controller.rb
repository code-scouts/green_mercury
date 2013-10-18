class RejectedApplicationsController < ApplicationController
  def index
    if can? :update, MentorApplication.new
      @mentor_applications = MentorApplication.rejected
      @member_applications = MemberApplication.rejected
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end
end
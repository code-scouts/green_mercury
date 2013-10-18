class ReviewApplicationsController < ApplicationController
  def index
    if can? :update, MentorApplication.new
      @member_applications = MemberApplication.pending
      @mentor_applications = MentorApplication.pending
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

end
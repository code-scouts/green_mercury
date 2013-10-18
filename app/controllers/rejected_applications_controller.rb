class RejectedApplicationsController < ApplicationController
  skip_before_filter :new_applicant
  def index
    @mentor_applications = MentorApplication.rejected
    @member_applications = MemberApplication.rejected
  end
end
class ReviewApplicationsController < ApplicationController
  skip_before_filter :new_applicant
  def index
    @member_applications = MemberApplication.pending
    @mentor_applications = MentorApplication.pending
  end

end
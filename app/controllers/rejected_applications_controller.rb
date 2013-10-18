class RejectedApplicationsController < ApplicationController
  def index
    @rejected_mentor_applications = MentorApplication.rejected
    @rejected_member_applications = MemberApplication.rejected
  end
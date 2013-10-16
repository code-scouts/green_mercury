class MemberApplicationsController < ApplicationController
  skip_before_filter :new_applicant?, only: [:new, :create]

  def new
    @member_application = MemberApplication.new(user_uuid: current_user.uuid)
  end

  def create
    @member_application = MemberApplication.new(member_application_params)
    if @member_application.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @application = MemberApplication.find(params[:id])
  end

private

  def member_application_params
    params.require(:member_application).permit(:why_you_want_to_join, :gender, :experience_level, :confidence_technical_skills, :basic_programming_knowledge, :comfortable_learning, :current_projects, :time_commitment, :hurdles, :excited_about, :anything_else, :user_uuid)
  end
end
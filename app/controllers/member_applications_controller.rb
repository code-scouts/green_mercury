class MemberApplicationsController < ApplicationController
  skip_before_filter :new_applicant, only: [:new, :create]

  def index
    @pending_member_applications = MemberApplication.pending
  end

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
    if can? :read, @application
      render 'show'
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

  def update 
    @application = MemberApplication.find(params[:id])
    if can? :update, @application
      @application.update(member_application_params)
      if @application.approved?
        flash[:notice] = "Application approved"
      else
        flash[:notice] = "Application rejected"
      end
      redirect_to member_applications_path
    else
      redirect_to member_applications_path, alert: "Not authorized"
    end   
  end

private

  def member_application_params
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
end
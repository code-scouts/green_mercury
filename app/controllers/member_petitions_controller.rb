class MemberPetitionsController < ApplicationController
  skip_before_filter :member_or_mentor

  def new
    @member_petition = MemberPetition.new(user_uuid: current_user.uuid)
  end

  def create
    @member_petition = MemberPetition.new(member_petition_params)
    if @member_petition.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

private

  def member_petition_params
    params.require(:member_petition).permit(:content, :user_uuid)
  end
end
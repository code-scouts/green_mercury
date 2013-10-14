class MentorPetitionsController < ApplicationController 
  def new
    @mentor_petition = MentorPetition.new(user_uuid: current_user.uuid)
  end

  def create
    @mentor_petition = MentorPetition.new(mentor_petition_params)
    if @mentor_petition.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

private

  def mentor_petition_params
    params.require(:mentor_petition).permit(:content, :user_uuid)
  end
end
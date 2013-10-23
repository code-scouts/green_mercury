class MentorParticipationsController < ApplicationController
  def update
    participation = MentorParticipation.find(params[:id])
    participation.update(user_uuid: current_user.uuid)
    redirect_to project_path(participation.project), notice: 'You have successfully joined the project!'
  end
end
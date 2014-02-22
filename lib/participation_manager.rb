module ParticipationManager
  def update
    participation = participation_model.find(params[:id])
    authorize! :update, participation
    participation.update(user_uuid: current_user.uuid)
    redirect_to project_path(participation.project), notice: 'You have successfully joined the project!'
  end
end
class EventOrganizersController < ApplicationController

  def create
    @event = Event.find(params[:id])
    @event_organizer = @event.event_organizers.new(event_organizer_params)
    if @event_organizer.save
      flash[:notice] = 'Organizer added'
      # do AJAX stuff to indicate new organizer
    else
      # do nothing
    end
  end

private

  def event_organizer_params
    params.require(:event_organizer).permit(:user_uuid)
  end
end

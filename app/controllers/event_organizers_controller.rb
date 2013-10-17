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

  def destroy
    # event_organizer = EventOrganizer.find(params[:id])
    # event_organizer.destroy
    # flash[:notice] = "Event organizer has been removed"
    #do AJAX stuff to indicate organizer has been removed
  end

private

  def event_organizer_params
    params.require(:event).permit(:user_uuid)
  end
end

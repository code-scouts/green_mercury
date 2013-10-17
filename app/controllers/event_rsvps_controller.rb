class EventRsvpsController < ApplicationController

  def create
    @event = Event.find(params[:id])
    @event_rsvp = @event.event_rsvps.new(event_rsvp_params)
    if @event_rsvp.save
      flash[:notice] = 'RSVP confirmed'
      # do AJAX stuff to indicate new RSVP
    else
      # do nothing
    end
  end

  def destroy
    # event_rsvp = EventRsvp.find(params[:id])
    # event_rsvp.destroy
    # flash[:notice] = "You have removed your RSVP for this event"
    #do AJAX stuff to indicate RSVP has been removed
  end

private

  def event_rsvp_params
    params.require(:event_rsvp).permit(:user_uuid)
  end
end

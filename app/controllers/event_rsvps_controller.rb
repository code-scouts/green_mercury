class EventRsvpsController < ApplicationController

  def create
    @event = Event.find(params[:id])
    @event_rsvp = @event.event_rsvps.new
    @event_rsvp.user_uuid = current_user.uuid
    if @event_rsvp.save
      flash[:notice] = 'RSVP confirmed'
      redirect_to event_path @event
      # add AJAX
    else
      redirect_to event_path @event
      # add AJAX
    end
  end

  def destroy
    event = Event.find(params[:id])
    event_rsvp = EventRsvp.where(event_id: params[:id], user_uuid: current_user.uuid).first
    event_rsvp.destroy
    flash[:notice] = "You have removed your RSVP for this event"
    redirect_to event_path event
    #do AJAX stuff to indicate RSVP has been removed
  end
end

class EventRsvpsController < ApplicationController

  def create
    @event = Event.find(params[:id])
    @event_rsvp = @event.event_rsvps.new
    @event_rsvp.user_uuid = current_user.uuid
    @event_rsvp.save

    respond_to do |format|
      format.html { redirect_to event_path @event }
      format.js
    end
  end

  def destroy
    @event_rsvp = EventRsvp.find(params[:id])
    @event_rsvp.destroy
    @event = @event_rsvp.event
    @event_rsvp = @event.rsvp_for(current_user)
    
    respond_to do |format|
      format.html { redirect_to event_path @event }
      format.js
    end
  end
end

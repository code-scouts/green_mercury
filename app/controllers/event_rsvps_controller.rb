class EventRsvpsController < ApplicationController

  def create
    event_rsvp = EventRsvp.new(rsvp_params)
    event_rsvp.user_uuid = current_user.uuid
    event_rsvp.save
    respond_to do |format|
      format.html { redirect_to event_path(event_rsvp.event) }
      format.js
    end
  end

  def destroy
    event_rsvp = EventRsvp.find(params[:id])
    event = event_rsvp.event
    event_rsvp.destroy
    respond_to do |format|
      format.html { redirect_to event_path event }
      format.js
    end
  end

private
  def rsvp_params
    params.require(:event_rsvp).permit(:event_id)
  end
end

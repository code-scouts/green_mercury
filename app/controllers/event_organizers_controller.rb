class EventOrganizersController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    authorize! :manage, @event
    @event_organizer = @event.event_organizers.new(user_uuid: params[:user_uuid])
    @event_organizer.save if current_user.organizer?(@event)
    respond_to do |format|
      format.html { redirect_to event_path @event }
      format.js
    end
  end
end

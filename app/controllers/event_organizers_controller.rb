class EventOrganizersController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    authorize! :manage, @event
    @event.make_organizer_by_uuid(params[:user_uuid])
    respond_to do |format|
      format.html { redirect_to event_path @event }
      format.js
    end
  end
end

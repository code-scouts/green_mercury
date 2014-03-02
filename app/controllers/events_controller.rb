class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    authorize! :create, @event
    if @event.save
      @event.rsvp(current_user)
      @event.make_organizer(current_user)
      flash[:notice] = 'Your event has been created.'
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    @event = Event.includes(:event_rsvps).find(params[:id])
    authorize! :read, @event
  end

  def index
  end

  def edit
    @event = Event.find(params[:id])
    authorize! :update, @event
  end
  
  def update
    @event = Event.find(params[:id])
    authorize! :update, @event
    if @event.update(event_params)
      flash[:notice] = "Edit confirmed"
      redirect_to event_path @event
    else
      render 'edit'
    end
  end

  def destroy
    event = Event.find(params[:id])
    authorize! :destroy, event 
    event.destroy
    flash[:notice] = "Event has been deleted"
    redirect_to events_path
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :location, :start_time, :end_time)
  end
end

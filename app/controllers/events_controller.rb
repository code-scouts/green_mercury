class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:notice] = 'Your event has been created.'
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    @events = Event.all
  end

  def edit
  end
  
  def update
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    flash[:notice] = "Event has been deleted"
    redirect_to events_path
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :location, :date, :start_time, :end_time)
  end
end

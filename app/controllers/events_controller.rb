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
  end

  def index
  end

  def edit
  end
  
  def update
  end

  def destroy
  end

private

  def event_params
    params.require(:event).permit(:title, :description, :location, :date, :start_time, :end_time)
  end
end

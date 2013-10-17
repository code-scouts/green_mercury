class PublicEventsController < ApplicationController
  def new
    @public_event = PublicEvent.new
  end

  def create
    @public_event = PublicEvent.new(public_event_params)
    if @public_event.save
      flash[:notice] = 'Your event has been created.'
      redirect_to @public_event
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

  def public_event_params
    params.require(:public_event).permit(:title, :description, :location, :date, :start_time, :end_time)
  end
end

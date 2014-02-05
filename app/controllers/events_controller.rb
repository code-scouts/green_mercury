class EventsController < ApplicationController

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    authorize! :create, @event
    if @event.save
      @event.event_organizers.create(user_uuid: current_user.uuid)
      flash[:notice] = 'Your event has been created.'
      redirect_to @event
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    authorize! :read, @event
    @event_rsvp = @event.rsvp_for(current_user)
    @users = @event.all_rsvps
  end

  def index
    @date = params[:date] && Date.valid_date?(params[:date]) ? Date.parse(params[:date]) : Date.today
    @events_by_date = Event.for_month(@date).group_by(&:date)
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
    params.require(:event).permit(:title, :description, :location, :date, :start_time, :end_time)
  end
end

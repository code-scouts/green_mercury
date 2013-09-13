class EventsController < ApplicationController
  include EventsHelper

  def index
    unless current_user.present?
      redirect_to root_path
      return
    end
    unless current_user.meetup_token.present?
      redirect_to meetup_login_url
      return
    end

    begin
      @events = get_events(current_user.meetup_token)
    rescue NeedNewToken
      redirect_to meetup_login_url
    end
  end

  def rsvp
    begin
      #TODO: answer questions if the event has some
      rsvp_to_event(params[:id], current_user.meetup_token)
    rescue NeedNewToken
      redirect_to meetup_login_url
    else
      redirect_to events_path
    end
  end

  def get_token
    current_user.meetup_token = exchange_code_for_token(params[:code])

    redirect_to events_path
  end
end

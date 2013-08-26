class EventsController < ApplicationController
  def index
    redirect_to meetup_login_url and return unless current_user.meetup_token.present?

    #TODO: CREAM
    response = HTTParty.get('https://api.meetup.com/2/events', {query: {
      group_urlname: 'Portland-Code-Scouts',
      access_token: current_user.meetup_token,
      fields: 'self',
    }})

    body = JSON.parse(response.body)
    redirect_to meetup_login_url and return if response['code'] == 'not_authorized'
    meetups = body['results']
    @events = meetups.map do |meetup|
      {
        time: Time.at(meetup['time'] / 1000).strftime('%A, %-d %b %-I:%M %p'),
        name: meetup['name'],
        url: meetup['event_url'],
        going: ((meetup['self']['rsvp'] || {})['response'] == 'yes'),
        id: meetup['id']
      }
    end
  end

  def rsvp
    event_id = params[:id]
    #TODO: answer questions if the event has some
    response = HTTParty.post('https://api.meetup.com/2/rsvp', {query: {
      event_id: event_id,
      rsvp: 'yes',
      access_token: current_user.meetup_token,
    }})
    redirect_to meetup_login_url and return if response['code'] == 'not_authorized'
    redirect_to events_path
  end

  def get_token
    response = HTTParty.post('https://secure.meetup.com/oauth2/access', {
      body: {
        client_id: MEETUP_API_KEY,
        client_secret: MEETUP_API_SECRET,
        grant_type: 'authorization_code',
        redirect_uri: events_get_token_url,
        code: params[:code],
      }
    })

    body = JSON.parse response.body
    raise Exception.new(response.body) unless body.has_key? 'access_token'
    current_user.meetup_token = body['access_token']
    current_user.save

    redirect_to events_path
  end

  def meetup_login_url
    'https://secure.meetup.com/oauth2/authorize'\
    "?client_id=#{MEETUP_API_KEY}"\
    '&response_type=code'\
    "&redirect_uri=#{events_get_token_url}"
  end
end

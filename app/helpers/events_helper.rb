module EventsHelper
  def get_events(access_token)
    #TODO: CREAM
    response = HTTParty.get('https://api.meetup.com/2/events', {query: {
      group_urlname: 'Portland-Code-Scouts',
      access_token: access_token,
      fields: 'self',
    }})

    body = JSON.parse(response.body)
    raise NeedNewToken if body['code'] == 'not_authorized'

    meetups = body['results']
    meetups.map do |meetup|
      {
        time: Time.at((meetup['time'] + meetup['utc_offset']) / 1000).\
              utc.\
              strftime('%A, %-d %b %-I:%M %p'),
        name: meetup['name'],
        url: meetup['event_url'],
        going: ((meetup['self']['rsvp'] || {})['response'] == 'yes'),
        id: meetup['id']
      }
    end
  end

  def rsvp_to_event(event_id, access_token)
    response = HTTParty.post('https://api.meetup.com/2/rsvp', {body: {
      event_id: event_id,
      rsvp: 'yes',
      access_token: access_token
    }})

    body = JSON.parse(response.body)
    raise NeedNewToken.new if body['code'] == 'not_authorized'
  end

  def exchange_code_for_token(code)
    response = HTTParty.post('https://secure.meetup.com/oauth2/access', {
      body: {
        client_id: MEETUP_API_KEY,
        client_secret: MEETUP_API_SECRET,
        grant_type: 'authorization_code',
        redirect_uri: events_get_token_url,
        code: code,
      }
    })

    body = JSON.parse response.body
    # what happens here if no access_token is granted?
    body['access_token']
  end

  def meetup_login_url
    'https://secure.meetup.com/oauth2/authorize'\
    "?client_id=#{MEETUP_API_KEY}"\
    '&response_type=code'\
    "&redirect_uri=#{events_get_token_url}"
  end

end

class NeedNewToken < StandardError; end

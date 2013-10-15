class User
  attr_accessor :meetup_token, :email, :confirmed_at, :uuid, :displayName

  def self.fetch_from_token(token)
    response = HTTParty.post(CAPTURE_URL + '/entity', {body:{
      access_token: token,
      type_name: 'user',
    }})

    body = JSON.parse(response.body)
    from_hash(body['result'])
  end

  def self.from_hash(hash)
    this = new
    this.meetup_token = hash['meetup_token']
    this.email = hash['email']
    this.confirmed_at = hash['emailVerified']
    this.uuid = hash['uuid']
    this.displayName = hash['displayName']
    this
  end
end

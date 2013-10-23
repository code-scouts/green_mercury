class AccessTokenExpired < StandardError; end

class User
  CACHE_TTL = 5 * 60 #seconds
  attr_accessor :meetup_token, :email, :confirmed_at, :profile_photo_url, :uuid, :is_admin, :name

  def self.fetch_from_token(token)
    Rails.cache.fetch("user_token:#{token}", expires_in: CACHE_TTL) do
      response = HTTParty.post(CAPTURE_URL + '/entity', {body:{
        access_token: token,
        type_name: 'user',
      }})

      body = JSON.parse(response.body)

      if body.has_key?('result')
        from_hash(body['result'])
      elsif body['error'] == 'access_token_expired'
        raise AccessTokenExpired
      else
        raise StandardError.new(response.body)
      end
    end
  end

  def self.fetch_from_uuid(uuid)
    response = HTTParty.post(CAPTURE_URL + '/entity', {body:{
      uuid: uuid,
      type_name: 'user',
      client_id: CAPTURE_OWNER_CLIENT_ID,
      client_secret: CAPTURE_OWNER_CLIENT_SECRET
    }})

    body = JSON.parse(response.body)
    if body.has_key?('result')
      from_hash(body['result'])
    elsif body['error'] == 'record_not_found'
      nil
    else
      #this is an exceptional case. Something is wrong with our Capture
      #integration. Just vomit the response and let the maintainers sort it out.
      raise StandardError.new(response.body)
    end
  end

  def self.fetch_from_uuids(uuids)
    uuid_string = uuids.map { |uuid| "uuid='#{uuid}'" }.join(' or ')

    response = HTTParty.post(CAPTURE_URL + '/entity.find', {body:{
      filter: uuid_string,
      type_name: 'user',
      client_id: CAPTURE_OWNER_CLIENT_ID,
      client_secret: CAPTURE_OWNER_CLIENT_SECRET
    }})

    body = JSON.parse(response.body)

    users = body['results'].map { |user_hash| from_hash(user_hash) }
    users_by_id = Hash[users.map { |user| [user.uuid, user] }]
  end

  def self.from_hash(hash)
    this = new
    this.meetup_token = hash['meetup_token']
    this.email = hash['email']
    this.confirmed_at = hash['emailVerified']
    this.uuid = hash['uuid']
    this.is_admin = hash['is_admin']
    this.name = hash['displayName']
    if hash['photos']
      profile_photo = hash['photos'].find do |record|
        record['type'] == 'normal'
      end
      this.profile_photo_url = profile_photo['value'] if profile_photo
    end
    this.instance_variable_set(:@display_rules, hash['display'])
    this.instance_variable_set(:@display_name, hash['displayName'])
    this.instance_variable_set(:@about_me, hash['aboutMe'])
    this
  end

  def member_application
    MemberApplication.find_by(user_uuid: uuid)
  end

  def mentor_application
    MentorApplication.find_by(user_uuid: uuid)
  end

  def is_admin?
    is_admin || false
  end

  def is_member?
    !member_application.nil? && member_application.approved?
  end

  def is_mentor?
    !mentor_application.nil? && mentor_application.approved?
  end

  def is_pending?
    !is_admin? && ((member_application && !is_member?) || (mentor_application && !is_mentor?))
  end

  def is_new?
    member_application.nil? && mentor_application.nil? && !is_admin?
  end

  def self.refresh_token(refresh_token)
    get_token(grant_type: 'refresh_token', refresh_token: refresh_token)
  end

  def self.acquire_token(code)
    get_token(grant_type: 'authorization_code', code: code)
  end

  def self.get_token(post_args)
    body = {
      redirect_uri: CAPTURE_URL,
      client_id: CAPTURE_OWNER_CLIENT_ID,
      client_secret: CAPTURE_OWNER_CLIENT_SECRET,
    }.merge(post_args)
    response = HTTParty.post(CAPTURE_URL+'/oauth/token', {body: body})

    body = JSON.parse(response.body)
    [body['access_token'], body['refresh_token']]
  end

  def display_name
    if @display_rules['displayName'] == 'true'
      @display_name
    else
      '<hidden>'
    end
  end

  def about_me
    if @display_rules['aboutMe'] == 'true'
      @about_me
    else
      '<hidden>'
    end
  end

  def requests
    if is_mentor?
      Request.where(mentor_uuid: self.uuid)
    else
      Request.where(member_uuid: self.uuid)
    end
  end
end
















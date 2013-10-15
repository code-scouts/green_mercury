class User
  attr_accessor :meetup_token, :email, :confirmed_at, :uuid, :is_admin

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
    this.is_admin = hash['is_admin']
    this
  end

  def member_petition
    MemberPetition.find_by(user_uuid: uuid)
  end

  def mentor_petition
    MentorPetition.find_by(user_uuid: uuid)
  end

  def is_admin?
    is_admin || false
  end

  def is_member?
    member_petition && member_petition.approved_date
  end

  def is_mentor?
    mentor_petition && mentor_petition.approved_date
  end

  def is_pending?
    !is_admin? && ((member_petition && !is_member?) || (mentor_petition && !is_mentor?))
  end

  def is_new?
    member_petition.nil? && mentor_petition.nil? && !is_admin?
  end
end
















class AccessTokenExpired < StandardError; end

class User
  attr_accessor :meetup_token, :email, :confirmed_at, :profile_photo_url, :uuid, :is_admin, :name

  extend JanrainCapturable

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

  def claimed_meeting_requests
    if is_mentor?
      MeetingRequest.where(mentor_uuid: self.uuid)
    else
      MeetingRequest.where(["member_uuid = ? AND mentor_UUID IS NOT null", self.uuid])
    end
  end

  def open_meeting_requests
    if is_mentor?
      MeetingRequest.where(mentor_uuid: nil)
    else
      MeetingRequest.where(member_uuid: self.uuid, mentor_uuid: nil)
    end
  end

  def events
    if @events.nil?
      rsvped_event_ids = Set.new(EventRsvp.where(user_uuid: self.uuid).map(&:event_id))
      @events = Event.upcoming_events.keep_if { |event| rsvped_event_ids.include?(event.id) }
    else
      @events
    end
  end

  def events_without_rsvp
    Event.upcoming_events - events
  end

  def organizer?(event)
    user_uuid = uuid
    event.event_organizers.any? do |organizer|
      organizer.user_uuid == user_uuid
    end
  end

  def accept_code_of_conduct
    response = HTTParty.post(CAPTURE_URL + '/entity.update', {body:{
      uuid: uuid,
      client_id: CAPTURE_OWNER_CLIENT_ID,
      client_secret: CAPTURE_OWNER_CLIENT_SECRET,
      type_name: 'user',
      attribute_name: 'coc_accepted_date',
      value: %Q("#{Date.today.to_s}"),
    }})
    body = JSON.parse(response.body)
    body['stat'] == 'ok' or raise Exception.new(response.body)
  end
end

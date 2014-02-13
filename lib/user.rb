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
end

class Event < ActiveRecord::Base
  has_many :event_rsvps
  has_many :event_organizers
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_datetime :start_time, on_or_after: :now
  validates_datetime :end_time, after: :start_time

  def rsvp?(user)
    EventRsvp.where(user_uuid: user.uuid, event_id: self.id).length > 0
  end

  def rsvp_for(user)
    if self.rsvp?(user)
      EventRsvp.where(user_uuid: user.uuid, event_id: self.id).first
    else
      EventRsvp.new
    end
  end

  def all_rsvps
    uuids = event_rsvps.map { |rsvp| rsvp.user_uuid }
    User.fetch_from_uuids(uuids)
  end

  def organizers
    uuids = event_organizers.map { |organizer| organizer.user_uuid }
    User.fetch_from_uuids(uuids)
  end

  def attendees
    all_organizers = event_organizers.map { |organizer| organizer.user_uuid }
    uuids = event_rsvps.map { |rsvp| rsvp.user_uuid }.delete_if { |attendee| all_organizers.include?(attendee) }
    User.fetch_from_uuids(uuids)
  end

  def self.upcoming_events
    where("start_time >= ?", Time.now)
  end
end

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
    event_rsvps.where(user_uuid: user.uuid).exists?
  end

  def rsvp_for(user)
    event_rsvps.where(user_uuid: user.uuid).first
  end

  def users_hash
    uuids = event_rsvps.pluck(:user_uuid)
    User.fetch_from_uuids(uuids)
  end

  def organizers_hash
    uuids = event_organizers.pluck(:user_uuid)
    User.fetch_from_uuids(uuids)
  end

  def attendees_hash
    all_organizers = event_organizers.map { |organizer| organizer.user_uuid }
    uuids = event_rsvps.map { |rsvp| rsvp.user_uuid }.delete_if { |attendee| all_organizers.include?(attendee) }
    User.fetch_from_uuids(uuids)
  end

  def self.upcoming_events
    where("start_time >= ?", Time.now)
  end
end

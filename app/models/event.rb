class Event < ActiveRecord::Base
  has_many :event_rsvps
  has_many :event_organizers
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  before_save :validate_date
  before_save :validate_end_time
  default_scope -> { order('date ASC') }

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
    Event.where("date >= ?", Date.today)
  end

  def self.for_month(month, year)
    first_of_month = Date.new(year, month)
    where("date >= ? AND date <= ?", first_of_month, first_of_month + 1.month)
  end

private

  def validate_date
    self.date >= Date.today
  end

  def validate_end_time
    self.end_time > self.start_time
  end
end
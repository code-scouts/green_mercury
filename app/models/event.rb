class Event < ActiveRecord::Base
  has_many :event_rsvps, dependent: :destroy
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates_datetime :start_time, on_or_after: :now
  validates_datetime :end_time, after: :start_time

  def rsvp(user)
    event_rsvps.create(user_uuid: user.uuid)
  end

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
    uuids = event_rsvps.where(organizer: true).pluck(:user_uuid)
    User.fetch_from_uuids(uuids)
  end

  def attendees_hash
    uuids = event_rsvps.where(organizer: false).pluck(:user_uuid)
    User.fetch_from_uuids(uuids)
  end

  def self.upcoming_events
    where("start_time >= ?", Time.now)
  end

  def organizer?(user)
    event_rsvps.where(user_uuid: user.uuid, organizer: true).exists?
  end

  def make_organizer(user)
    rsvp_for(user).make_organizer
  end

  def make_organizer_by_uuid(uuid)
    event_rsvps.where(user_uuid: uuid).first.make_organizer
  end
end

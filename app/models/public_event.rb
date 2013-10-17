class PublicEvent < ActiveRecord::Base
  # has_many :public_event_rsvps
  # has_many :public_event_organizers
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
class Event < ActiveRecord::Base
  # has_many :event_rsvps
  # has_many :event_organizers
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true
  validates :location, presence: true, length: { maximum: 200 }
  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  before_save :validate_date
  before_save :validate_end_time


private

  def validate_date
    self.date >= Date.today
  end

  def validate_end_time
    self.end_time > self.start_time
  end
end
class MentorApplication < ActiveRecord::Base
  validates :user_uuid, presence: true
  validates :name, presence: true
  validates :contact, presence: true
  validates :geography, presence: true
  validates :hear_about, presence: true
  validates :motivation, presence: true
  validates :time_commitment, presence: true
  validates :mentor_one_on_one, presence: true
  validates :mentor_group, presence: true
  validates :mentor_online, presence: true
  validates :volunteer_events, presence: true
  validates :volunteer_teams, presence: true
  validates :volunteer_solo, presence: true
  validates :volunteer_technical, presence: true
  validates :volunteer_online, presence: true

  def self.pending 
    MentorApplication.where(approved_date: nil)
  end
end
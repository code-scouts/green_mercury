class Project < ActiveRecord::Base
  has_many :participations
  validates :title, presence: true
  validates :description, presence: true
  validates :max_members, presence: true
  validates :max_mentors, presence: true
end
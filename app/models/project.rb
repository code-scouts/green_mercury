class Project < ActiveRecord::Base
  has_many :member_participations
  has_many :mentor_participations
  validates :title, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :mentor_participations

end
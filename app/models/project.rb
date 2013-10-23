class Project < ActiveRecord::Base
  has_many :participations
  validates :title, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :participations
end
class Participation < ActiveRecord::Base
  validates :role, presence: true
end
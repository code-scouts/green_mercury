class MentorPetition < ActiveRecord::Base
  validates :content, presence: true, length: { maximum: 5000 } 
end
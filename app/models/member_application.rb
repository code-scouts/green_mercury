class MemberApplication < ActiveRecord::Base
  validates :why_you_want_to_join, presence: true 
  validates :experience_level, presence: true 
  validates :comfortable_learning, presence: true 
  validates :time_commitment, presence: true 
end
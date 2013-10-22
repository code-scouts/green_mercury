class Participation < ActiveRecord::Base
  belongs_to :project
  validates :user_uuid, presence: true
end
class Participation < ActiveRecord::Base
  validates :role, presence: true

  def self.unfilled
  	where(user_uuid: nil)
  end
end

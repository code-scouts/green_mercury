class EventRsvp < ActiveRecord::Base
  belongs_to :event

  validates :event_id, uniqueness: { scope: :user_uuid }
end
class EventRsvp < ActiveRecord::Base
  belongs_to :event
  validates :user_uuid, uniqueness: { scope: :event_id }

  def make_organizer
    update(organizer: true)
  end
end

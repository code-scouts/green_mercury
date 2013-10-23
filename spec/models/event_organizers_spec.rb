require 'spec_helper'

describe EventOrganizer do
  it { should respond_to :user_uuid }
  it { should belong_to :event }

  it 'should should save if the event_id/user_uuid pair is unique' do
    EventOrganizer.create(event_id: 1, user_uuid: 'first-uuid')
    @event_organizer = EventOrganizer.create(event_id: 1, user_uuid: 'second-uuid')
    @event_organizer.save.should be_true
  end

  it 'should not should save if the event_id/user_uuid pair is not unique' do
    EventOrganizer.create(event_id: 1, user_uuid: 'first-uuid')
    @event_organizer = EventOrganizer.create(event_id: 1, user_uuid: 'first-uuid')
    @event_organizer.save.should be_false
  end
end
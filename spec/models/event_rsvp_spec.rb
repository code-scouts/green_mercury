require 'spec_helper'

describe EventRsvp do

  it { should belong_to :event }
  it { should respond_to :user_uuid }

  it 'should should save if the event_id/user_uuid pair is unique' do
    EventRsvp.create(event_id: 1, user_uuid: 'first-uuid')
    @event_rsvp = EventRsvp.create(event_id: 1, user_uuid: 'second-uuid')
    @event_rsvp.save.should be_true
  end

  it 'should not should save if the event_id/user_uuid pair is not unique' do
    EventRsvp.create(event_id: 1, user_uuid: 'first-uuid')
    @event_rsvp = EventRsvp.create(event_id: 1, user_uuid: 'first-uuid')
    @event_rsvp.save.should be_false
  end

end
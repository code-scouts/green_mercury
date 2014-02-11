require 'spec_helper'

describe Event do
  
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :location }
  it { should respond_to :start_time }
  it { should respond_to :end_time }

  it { should have_many :event_organizers }
  it { should have_many :event_rsvps }
  
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :description }
  it { should validate_presence_of :location }
  it { should ensure_length_of(:location).is_at_most(200) }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  it 'validates the start time is not in the past' do
    event = FactoryGirl.build(:event, start_time: Time.now - 1.day)
    expect(event.save).to be_false
  end

  it 'validates the end time is after the start time' do
    event = FactoryGirl.build(:event, start_time: Time.now + 2.day, end_time: Time.now + 1.day)
    expect(event.save).to be_false
  end

  describe 'rsvp?' do
    before do
      @event = FactoryGirl.create(:event)
      @user = FactoryGirl.build(:user)
    end

    it 'should return true if the user has RSVPd to the event' do
      @event.event_rsvps.create(user_uuid: @user.uuid)
      @event.rsvp?(@user).should be_true
    end

    it 'should return false if the user has not RSVPd to the event' do
      @event.rsvp?(@user).should be_false
    end
  end

  describe 'rsvp_for' do
    before do
      @event = FactoryGirl.create(:event)
      @user = FactoryGirl.build(:user)
    end

    it 'should return the correct EventRsvp object if the user requested has RSVPd to the event' do
      event_rsvp = @event.event_rsvps.create(user_uuid: @user.uuid)
      @event.rsvp_for(@user).should eq event_rsvp
    end

    it 'should return a new EventRsvp object if the user requested has not RSVPd to the event' do
      @event.rsvp_for(@user).should be_a(EventRsvp)
    end
  end

  describe 'all_rsvps' do
    it 'should return a hash of uuids and user objects for all users who have RSVPd to the event' do
      event = FactoryGirl.create(:event)
      user = FactoryGirl.build(:user)
      event.event_rsvps.create(user_uuid: user.uuid)
      User.should_receive(:fetch_from_uuids).with([user.uuid])
      event.all_rsvps
    end
  end

  describe 'organizers' do
    it 'should return an array of all organizers for the event' do
      event = FactoryGirl.create(:event)
      user = FactoryGirl.build(:user)
      event.event_organizers.create(user_uuid: user.uuid)
      User.should_receive(:fetch_from_uuids).with([user.uuid])
      event.organizers
    end
  end

  describe 'attendees' do
    it 'should return an array of all attendees who are not organizers for the event' do
      event = FactoryGirl.create(:event)
      user1 = FactoryGirl.build(:user, name: 'User 1', uuid: 'one-uuid')
      user2 = FactoryGirl.build(:user, name: 'User 2', uuid: 'two-uuid')
      event.event_organizers.create(user_uuid: user1.uuid)
      event.event_rsvps.create(user_uuid: user1.uuid)
      event.event_rsvps.create(user_uuid: user2.uuid)
      User.should_receive(:fetch_from_uuids).with([user2.uuid])
      event.attendees
    end
  end

  describe '.upcoming_events' do
    it 'gets events that start after the current time' do
      event = FactoryGirl.create(:event, start_time: Time.now + 1.hour, end_time: Time.now + 1.day)
      expect(Event.upcoming_events).to match_array [event]
    end

    it 'does not get events that happened before the current time' do
      past_time = Time.now - 1.month
      Timecop.travel(past_time) 
      event = FactoryGirl.create(:event, start_time: past_time + 1.day, end_time: past_time + 2.days)
      Timecop.return
      expect(Event.upcoming_events).to_not include(event)
    end
  end
end








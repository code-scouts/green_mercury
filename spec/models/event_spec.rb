require 'spec_helper'

describe Event do
  
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :location }
  it { should respond_to :date }
  it { should respond_to :start_time }
  it { should respond_to :end_time }

  it { should have_many :event_organizers }
  it { should have_many :event_rsvps }
  
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :description }
  it { should validate_presence_of :location }
  it { should ensure_length_of(:location).is_at_most(200) }
  it { should validate_presence_of :date }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  it 'should save if date is equal to or later than today' do
    event = FactoryGirl.build(:event)
    event.save.should be_true
  end

  it 'should not save if date is before today' do
    event = FactoryGirl.build(:event, date: Date.yesterday)
    event.save.should be_false
  end

  it 'should save if end time is after start time' do
    event = FactoryGirl.build(:event)
    event.save.should be_true
  end

  it 'should not save if end time is equal to or before start time' do
    time = Time.now
    event = FactoryGirl.build(:event, start_time: time, end_time: time)
    event.save.should be_false
  end

  it 'should return events sorted by date' do
    event1 = FactoryGirl.create(:event, date: Date.today)
    event2 = FactoryGirl.create(:event, date: (Date.today + 2.days))
    event3 = FactoryGirl.create(:event, date: (Date.today + 1.day))
    Event.all.should eq [event1, event3, event2]
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
      User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
      event_rsvp = event.event_rsvps.create(user_uuid: user.uuid)
      event.all_rsvps[user.uuid].should eq user
    end
  end
end








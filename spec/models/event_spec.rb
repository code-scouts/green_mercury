require 'spec_helper'

describe Event do
  
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :location }
  it { should respond_to :date }
  it { should respond_to :start_time }
  it { should respond_to :end_time }

  it { should have_many :event_organizers }
  # it { should have_many :event_rsvps }
  
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
end
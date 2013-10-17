require 'spec_helper'

describe PublicEvent do
  
  it { should respond_to :title }
  it { should respond_to :description }
  it { should respond_to :location }
  it { should respond_to :date }
  it { should respond_to :start_time }
  it { should respond_to :end_time }

  # it { should have_many :public_event_organizers }
  # it { should have_many :public_event_rsvps }
  
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :description }
  it { should validate_presence_of :location }
  it { should ensure_length_of(:location).is_at_most(200) }
  it { should validate_presence_of :date }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

end
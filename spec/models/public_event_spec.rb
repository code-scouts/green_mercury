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
  
end
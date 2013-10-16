require 'spec_helper'

describe MentorApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }
  it { should validate_presence_of :user_uuid }
  it { should validate_presence_of :name }
  it { should validate_presence_of :contact }
  it { should validate_presence_of :geography }
  it { should validate_presence_of :hear_about }
  it { should validate_presence_of :motivation }
  it { should validate_presence_of :time_commitment }
  it { should validate_presence_of :mentor_one_on_one }
  it { should validate_presence_of :mentor_group }
  it { should validate_presence_of :mentor_online }
  it { should validate_presence_of :volunteer_events }
  it { should validate_presence_of :volunteer_teams }
  it { should validate_presence_of :volunteer_solo }
  it { should validate_presence_of :volunteer_technical }
  it { should validate_presence_of :volunteer_online }

  describe "pending" do 
    it "returns all pending mentor applications" do 
      application = FactoryGirl.create(:mentor_application)
      MentorApplication.pending.should eq [application]
    end
  end
end
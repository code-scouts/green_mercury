require 'spec_helper'

describe EventRsvp do
  it { should belong_to :event }
  it { should respond_to :user_uuid }
  it { should validate_uniqueness_of(:user_uuid).scoped_to(:event_id) }

  describe "#make_organizer" do 
    it "sets the organizer attribute to true" do 
      event_rsvp = FactoryGirl.create(:event_rsvp)
      event_rsvp.make_organizer
      expect(event_rsvp.organizer?).to be_true
    end
  end
end

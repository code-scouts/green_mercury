require 'spec_helper'

describe Ability do
  it "restricts actions for non-organizers of events" do
    user = FactoryGirl.build(:user)
    ability = Ability.new(user)
    ability.should be_able_to(:create, Event.new)
    ability.should be_able_to(:read, Event.new)
    ability.should_not be_able_to(:update, Event.new)
    ability.should_not be_able_to(:destroy, Event.new)
  end

end
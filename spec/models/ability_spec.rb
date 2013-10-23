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

  it 'lets an admin approve a mentor application' do 
    user = FactoryGirl.build(:admin)
    ability = Ability.new(user)
    ability.should be_able_to(:update, FactoryGirl.create(:mentor_application))
  end

  it 'lets an admin approve a member application' do 
    user = FactoryGirl.build(:admin)
    ability = Ability.new(user)
    ability.should be_able_to(:update, FactoryGirl.create(:member_application))
  end

  it 'lets a member create, edit, or view a request' do
    user = new_member
    ability = Ability.new(user)
    ability.should be_able_to(:create, Request.new(member_uuid: user.uuid))
    ability.should be_able_to(:update, Request.new(member_uuid: user.uuid))
    ability.should be_able_to(:read, Request.new(member_uuid: 'should-be-member-uuid'))
  end

  it 'prevents a member from editing another member\'s request' do
    user = new_member
    ability = Ability.new(user)
    ability.should_not be_able_to(:update, Request.new(member_uuid: 'should-not-member-uuid'))
  end

  it 'prevents a mentor from creating or editing a request, allows mentors to view requests' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should_not be_able_to(:create, Request.new(member_uuid: user.uuid))
    ability.should_not be_able_to(:update, Request.new)
    ability.should be_able_to(:read, Request.new)
  end

  it 'lets a mentor (not member) claim an open request' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should be_able_to(:claim, Request.new)
  end

  it 'prevents a member (not mentor) from claiming a request' do
    user = new_member
    ability = Ability.new(user)
    ability.should_not be_able_to(:claim, Request.new)
  end

  it 'prevents a mentor from claiming an already-claimed request' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should_not be_able_to(:claim, FactoryGirl.create(:request, mentor_uuid: 'mentor-uuid'))
  end
end











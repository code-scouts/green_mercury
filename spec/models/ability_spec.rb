require 'spec_helper'

describe Ability do 
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
end
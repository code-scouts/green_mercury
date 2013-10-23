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

  it 'allows a mentor to create a project' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should be_able_to(:create, Project.new)
  end

  it 'does not allow a non-mentor to create a project' do
    user = new_member
    ability = Ability.new(user)
    ability.should_not be_able_to(:create, Project.new)
  end
end
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

  it 'allows a mentor to join a project that has an open mentor slot' do 
    user = new_mentor
    ability = Ability.new(user)
    project = FactoryGirl.create(:project)
    participation = FactoryGirl.create(:mentor_participation, project: project, user_uuid: nil)
    filled_participation = FactoryGirl.create(:mentor_participation, project: project)
    ability.should be_able_to(:update, participation)
    ability.should_not be_able_to(:update, filled_participation)
  end

  it 'allows a mentor to join a project that they are not currently a participant of' do 
    user = new_mentor
    ability = Ability.new(user)
    project = FactoryGirl.create(:project)
    participation = FactoryGirl.create(:mentor_participation, project: project, user_uuid: user.uuid)
    unfilled_participation = FactoryGirl.create(:mentor_participation, project: project, user_uuid: nil)
    ability.should_not be_able_to(:update, unfilled_participation)
  end
end
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

  it 'allows a mentor to join a project that has an open mentor slot as long as they are not already a participant' do 
    user = new_mentor
    ability = Ability.new(user)

    project1 = FactoryGirl.create(:project)
    valid_participation = FactoryGirl.create(:mentor_participation, project: project1, user_uuid: nil)
    ability.should be_able_to(:update, valid_participation)

    full_participation = FactoryGirl.create(:mentor_participation, project: project1)
    ability.should_not be_able_to(:update, full_participation)

    project2 = FactoryGirl.create(:project)
    user_participation = FactoryGirl.create(:mentor_participation, project: project2, user_uuid: user.uuid)
    available_participation = FactoryGirl.create(:mentor_participation, project: project2, user_uuid: nil)
    ability.should_not be_able_to(:update, available_participation)
  end
end
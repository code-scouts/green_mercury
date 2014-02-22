require 'spec_helper'

describe Ability do
  it "restricts actions for non-organizers of events" do
    user = new_member
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

  it 'allows a member to join a project that has an open member slot as long as they are not already a participant' do 
    user = new_member
    ability = Ability.new(user)

    project1 = FactoryGirl.create(:project)
    valid_participation = FactoryGirl.create(:member_participation, project: project1, user_uuid: nil)
    ability.should be_able_to(:update, valid_participation)

    full_participation = FactoryGirl.create(:member_participation, project: project1)
    ability.should_not be_able_to(:update, full_participation)

    project2 = FactoryGirl.create(:project)
    user_participation = FactoryGirl.create(:member_participation, project: project2, user_uuid: user.uuid)
    available_participation = FactoryGirl.create(:member_participation, project: project2, user_uuid: nil)
    ability.should_not be_able_to(:update, available_participation)
  end

  it 'allows a participant of a project to participate' do
    user = new_member
    ability = Ability.new(user)
    project = FactoryGirl.create(:project)
    FactoryGirl.create(:member_participation, project: project, user_uuid: user.uuid)
    ability.should be_able_to(:participate, project)
  end

  it 'allows a project owner to update a project' do 
    user = new_mentor
    ability = Ability.new(user)
    project = FactoryGirl.create(:project, user_uuid: user.uuid)
    ability.should be_able_to(:update, project)
  end 

  it 'lets a member create, edit, or view a request' do
    user = new_member
    ability = Ability.new(user)
    ability.should be_able_to(:create, MeetingRequest.new(member_uuid: user.uuid))
    ability.should be_able_to(:update, MeetingRequest.new(member_uuid: user.uuid))
    ability.should be_able_to(:read, MeetingRequest.new(member_uuid: 'should-be-member-uuid'))
  end

  it 'prevents a member from editing another member\'s request' do
    user = new_member
    ability = Ability.new(user)
    ability.should_not be_able_to(:update, MeetingRequest.new(member_uuid: 'should-not-member-uuid'))
  end

  it 'prevents a mentor from creating or editing a request, allows mentors to view requests' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should_not be_able_to(:create, MeetingRequest.new(member_uuid: user.uuid))
    ability.should_not be_able_to(:update, MeetingRequest.new)
    ability.should be_able_to(:read, MeetingRequest.new)
  end

  it 'lets a mentor (not member) claim an open request' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should be_able_to(:claim, MeetingRequest.new)
  end

  it 'prevents a member (not mentor) from claiming a request' do
    user = new_member
    ability = Ability.new(user)
    ability.should_not be_able_to(:claim, MeetingRequest.new)
  end

  it 'prevents a mentor from claiming an already-claimed request' do
    user = new_mentor
    ability = Ability.new(user)
    ability.should_not be_able_to(:claim, FactoryGirl.create(:meeting_request, mentor_uuid: 'mentor-uuid'))
  end
end




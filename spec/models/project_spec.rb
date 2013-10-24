require 'spec_helper'

describe Project do   
  it { should have_many :mentor_participations }
  it { should have_many :member_participations }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should accept_nested_attributes_for :mentor_participations }
  it { should accept_nested_attributes_for :member_participations }
  it { should have_many :posts }

  describe 'mentor_participant?' do 
    it 'is true if the user is a mentor participant in the project' do 
      project = FactoryGirl.create(:project) 
      user = new_mentor 
      FactoryGirl.create(:mentor_participation, project: project, user_uuid: user.uuid)
      project.mentor_participant?(user).should be_true
    end

    it 'is false if the user is not a mentor participant in the project' do 
      project = FactoryGirl.create(:project)
      user = new_member
      FactoryGirl.create(:member_participation, project: project)
      project.mentor_participant?(user).should be_false
    end
  end

  describe 'member_participant?' do 
    it 'is true if the user is a member participant of the project' do 
      project = FactoryGirl.create(:project)
      user = new_member 
      FactoryGirl.create(:member_participation, project: project, user_uuid: user.uuid)
      project.member_participant?(user).should be_true
    end

    it 'is false if the user is not a member participant of the project' do 
      project = FactoryGirl.create(:project)
      user = new_member
      project.member_participant?(user).should be_false
    end
  end
end


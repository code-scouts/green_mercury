require 'spec_helper'

describe Project do   
  it { should have_many :mentor_participations }
  it { should have_many :member_participations }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should accept_nested_attributes_for :mentor_participations }
  it { should accept_nested_attributes_for :member_participations }
  it { should have_many :comments }
  it { should have_attached_file(:image) }

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

  describe '#available_for' do
    let!(:project1) { FactoryGirl.create(:project) }
    let!(:project2) {FactoryGirl.create(:project) }

    context 'when the user is a member' do 
      let(:user) { new_member }

      it 'is an array of projects they can join' do 
        FactoryGirl.create(:member_participation, project: project1, user_uuid: nil)
        expect(Project.available_for(user)).to match_array [project1]
      end
    end

    context 'when the user is a mentor' do
      let(:user) { new_mentor }

      it 'is an array of projects they can join' do  
        FactoryGirl.create(:mentor_participation, project: project2, user_uuid: nil)
        expect(Project.available_for(user)).to match_array [project2]
      end
    end
  end

  describe '#unavailable_for' do
    it 'returns an array of projects with no spaces left for members' do
      user = new_member
      project1 = FactoryGirl.create(:project)
      project2 = FactoryGirl.create(:project)
      FactoryGirl.create(:member_participation, project: project1, user_uuid: nil)
      FactoryGirl.create(:mentor_participation, project: project2, user_uuid: nil)
      expect(Project.unavailable_for(user)).to match_array [project2]
    end

    it 'returns an array of projects with no spaces left for mentors' do
      user = new_mentor
      project1 = FactoryGirl.create(:project)
      project2 = FactoryGirl.create(:project)
      FactoryGirl.create(:mentor_participation, project: project1, user_uuid: nil)
      FactoryGirl.create(:member_participation, project: project2, user_uuid: nil)
      expect(Project.unavailable_for(user)).to match_array [project2]
    end
  end
end


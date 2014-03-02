require 'spec_helper'

describe PreexistingMember do
  describe "application class" do
    it "should work for regular members" do
      preexisting = FactoryGirl.build(:preexisting_member)
      preexisting.application_class.should eq MemberApplication
    end

    it "should work for mentors" do
      preexisting = FactoryGirl.build(:preexisting_member, is_mentor: true)
      preexisting.application_class.should eq MentorApplication
    end
  end
end

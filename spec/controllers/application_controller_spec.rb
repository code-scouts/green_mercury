require 'spec_helper'

describe ApplicationController do
  before do
    ApplicationController.send :public, :member_or_mentor
  end

  context "admin" do
    it "can view the page" do 
      user = User.new()
      user.is_admin = true
      controller.stub(:current_user) { user }
      controller.member_or_mentor
      controller.performed?.should be_false  
    end
  end

  context "member" do 
    it "can view the page" do 
      user = User.new()
      MemberPetition.new(user_uuid: user.uuid, content: 'about me', approved_date: Date.today)
      controller.stub(:current_user) { user }
      controller.member_or_mentor
      controller.performed?.should be_false
    end
  end

  context "mentor" do 
    it "can view the page" do 
      user = User.new()
      MentorPetition.new(user_uuid: user.uuid, content: 'about me', approved_date: Date.today)
      controller.stub(:current_user) { user }
      controller.member_or_mentor
      controller.performed?.should be_false
    end
  end

  # context "mentor petition submitted (not yet approved)" do 
  #   it "is redirected to another page" do 
  #     user = User.new()
  #     MentorPetition.new(user_uuid: user.uuid, content: 'about me', approved_date: Date.today)
  #     controller.stub(:current_user) { user }
  #     controller.member_or_mentor
  #     controller.performed?.should be_true
  #   end    
  # end

  # context "member petition submitted (not yet approved)" do 
  #   it "is redirected to another page" do 
  #     user = User.new()
  #     MemberPetition.new(user_uuid: user.uuid, content: 'about me', approved_date: Date.today)
  #     controller.stub(:current_user) { user }
  #     controller.member_or_mentor
  #     controller.performed?.should be_true  
  #   end
  # end

  #no petition submitted

end

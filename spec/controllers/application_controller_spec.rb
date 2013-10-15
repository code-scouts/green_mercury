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
      FactoryGirl.create(:member_petition, user_uuid: user.uuid)
      controller.stub(:current_user) { user }
      controller.member_or_mentor
      controller.performed?.should be_false
    end
  end

  context "mentor" do 
    it "can view the page" do 
      user = User.new()
      FactoryGirl.create(:mentor_petition, user_uuid: user.uuid)
      controller.stub(:current_user) { user }
      controller.member_or_mentor
      controller.performed?.should be_false
    end
  end

  context "petition submitted (not yet approved)" do 
    it "is redirected to another page" do 
      user = User.new()
      FactoryGirl.create(:mentor_petition, user_uuid: user.uuid, approved_date: nil)
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/')
      controller.member_or_mentor
    end    
  end

  context "no petition submitted" do 
    it "is redirected to another page" do 
      user = User.new()
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/')
      controller.member_or_mentor
    end
  end
end

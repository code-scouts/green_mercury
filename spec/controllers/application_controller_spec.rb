require 'spec_helper'

describe ApplicationController do
  before do
    ApplicationController.send :public, :new_applicant
    ApplicationController.send :public, :pending_applicant
  end

  context "admin" do
    it "can view the page" do 
      user = FactoryGirl.build(:user)
      user.is_admin = true
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false  
    end
  end

  context "member" do 
    it "can view the page" do 
      user = new_member
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false
    end
  end

  context "mentor" do 
    it "can view the page" do 
      user = new_mentor
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false
    end
  end

  context "petition submitted (not yet approved)" do 
    it "is redirected to another page" do 
      user = FactoryGirl.build(:user)
      FactoryGirl.create(:mentor_application, user_uuid: user.uuid, approved_date: nil)
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/new_applications/show')
      controller.pending_applicant
    end    
  end

  context "no petition submitted" do 
    it "is redirected to another page" do 
      user = FactoryGirl.build(:user)
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/new_applications/index')
      controller.new_applicant
    end
  end
end

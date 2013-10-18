require 'spec_helper'

describe MemberApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }

  it { should validate_presence_of :name }
  it { should validate_presence_of :why_you_want_to_join }
  it { should validate_presence_of :experience_level }
  it { should validate_presence_of :comfortable_learning }
  it { should validate_presence_of :time_commitment }

  describe "pending" do 
    it "returns all pending mentor applications" do 
      application = FactoryGirl.create(:member_application)
      FactoryGirl.create(:rejected_member_application)
      MemberApplication.pending.should eq [application]
    end
  end

  describe 'rejected?' do 
    it "is true if the application has been rejected" do 
      application = FactoryGirl.create(:rejected_member_application)
      application.rejected?.should eq true
    end

    it "is true if the application was approved and then rejected" do
      application = FactoryGirl.create(:member_application, rejected_date: Date.today, approved_date: Date.yesterday)
      application.rejected?.should eq false
    end

    it "is false if the application has not been rejected" do 
      application = FactoryGirl.create(:approved_member_application)
      application.rejected?.should eq false
    end

    it "is false if the application is pending" do 
      application = FactoryGirl.create(:member_application)
      application.rejected?.should eq false
    end

    it "is false if the application was rejected and then approved" do
      application = FactoryGirl.create(:member_application, rejected_date: Date.yesterday, approved_date: Date.today)
      application.rejected?.should eq false
    end
  end

  describe 'approved?' do
    it "is true if the application has been approved" do
      application = FactoryGirl.create(:approved_member_application)
      application.approved?.should eq true
    end

    it "is true if the application was rejected and then approved" do
      application = FactoryGirl.create(:member_application, rejected_date: Date.yesterday, approved_date: Date.today)
      application.rejected?.should eq false
    end
    
    it "is false if the application has been rejected" do
      application = FactoryGirl.create(:rejected_member_application)
      application.approved?.should eq false
    end

    it "is false if the application is pending" do
      application = FactoryGirl.create(:member_application)
      application.approved?.should eq false
    end

    it "is false if the application was approved and then rejected" do
      application = FactoryGirl.create(:member_application, rejected_date: Date.today, approved_date: Date.yesterday)
      application.approved?.should eq false
    end
  end
end
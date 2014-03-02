require 'spec_helper'

describe MemberApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }

  it { should validate_presence_of :why_you_want_to_join }
  it { should validate_presence_of :experience_level }
  it { should validate_presence_of :comfortable_learning }
  it { should validate_presence_of :time_commitment }

  describe 'user' do
    it "gets the user with a matching uuid" do
      user = FactoryGirl.build(:user)
      application = FactoryGirl.create(:member_application, user_uuid: user.uuid)
      User.stub(:fetch_from_uuid) { user }
      application.user.should eq user
    end
  end

  describe "pending" do
    it "returns all pending mentor applications" do
      application = FactoryGirl.create(:member_application)
      FactoryGirl.create(:rejected_member_application)
      MemberApplication.pending.should eq [application]
    end
  end

  describe "rejected" do
    it "gets all members whose applications are rejected" do
      application = FactoryGirl.create(:rejected_member_application)
      MemberApplication.rejected.should eq [application]
    end
  end

  describe 'rejected?' do
    it "is true if the application has been rejected" do
      application = FactoryGirl.create(:rejected_member_application)
      application.rejected?.should eq true
    end

    it "is true if the application was approved and then rejected" do
      application = FactoryGirl.create(:member_application, rejected_date: Time.now, approved_date: Time.now - 1.day)
      application.rejected?.should eq true
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
      application = FactoryGirl.create(:member_application, rejected_date: Time.now - 1.day, approved_date: Time.now)
      application.rejected?.should eq false
    end
  end

  describe 'approved?' do
    it "is true if the application has been approved" do
      application = FactoryGirl.create(:approved_member_application)
      application.approved?.should eq true
    end

    it "is true if the application was rejected and then approved" do
      application = FactoryGirl.create(:member_application, rejected_date: Time.now - 1.day, approved_date: Time.now)
      application.approved?.should eq true
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
      application = FactoryGirl.create(:member_application, rejected_date: Time.now, approved_date: Time.now - 1.day)
      application.approved?.should eq false
    end
  end

  describe "approve_me" do
    before :each do
      @user = FactoryGirl.build(:user)
    end

    it "creates an approved record" do
      application = MemberApplication.approve_me(@user)
      application.approved?.should be_true
      application.user_uuid.should == @user.uuid
    end

    it "puts placeholders in the required fields" do
      application = MemberApplication.approve_me(@user)
      application.experience_level.should == '<pre-existing user>'
    end
  end
end

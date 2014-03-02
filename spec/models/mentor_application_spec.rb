require 'spec_helper'

describe MentorApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }
  it { should validate_presence_of :user_uuid }
  it { should validate_presence_of :contact }
  it { should validate_presence_of :geography }
  it { should validate_presence_of :hear_about }
  it { should validate_presence_of :motivation }
  it { should validate_presence_of :time_commitment }
  it { should validate_presence_of :mentor_one_on_one }
  it { should validate_presence_of :mentor_group }
  it { should validate_presence_of :mentor_online }
  it { should validate_presence_of :volunteer_events }
  it { should validate_presence_of :volunteer_teams }
  it { should validate_presence_of :volunteer_solo }
  it { should validate_presence_of :volunteer_technical }
  it { should validate_presence_of :volunteer_online }

  describe 'user' do
    it "gets the user with a matching uuid" do
      user = FactoryGirl.build(:user)
      application = FactoryGirl.create(:mentor_application, user_uuid: user.uuid)
      User.stub(:fetch_from_uuid) { user }
      application.user.should eq user
    end
  end

  describe "pending" do
    it "returns all pending mentor applications" do
      application = FactoryGirl.create(:mentor_application)
      FactoryGirl.create(:rejected_mentor_application)
      MentorApplication.pending.should eq [application]
    end
  end

  describe "rejected" do
    it "gets all mentors whose applications are rejected" do
      application = FactoryGirl.create(:rejected_mentor_application)
      application_b = FactoryGirl.create(:mentor_application, rejected_date: Time.now, approved_date: Time.now - 1.day)
      application_c = FactoryGirl.create(:mentor_application, rejected_date: Time.now - 1.day, approved_date: Time.now)
      MentorApplication.rejected.should include(application, application_b)
      MentorApplication.rejected.should_not include(application_c)
    end
  end

  describe 'rejected?' do
    it "is true if the application has been rejected" do
      application = FactoryGirl.create(:rejected_mentor_application)
      application.rejected?.should eq true
    end

    it "is true if the application was approved and then rejected" do
      application = FactoryGirl.create(:mentor_application, rejected_date: Time.now, approved_date: Time.now - 1.day)
      application.rejected?.should eq true
    end

    it "is false if the application has not been rejected" do
      application = FactoryGirl.create(:approved_mentor_application)
      application.rejected?.should eq false
    end

    it "is false if the application is pending" do
      application = FactoryGirl.create(:mentor_application)
      application.rejected?.should eq false
    end

    it "is false if the application was rejected and then approved" do
      application = FactoryGirl.create(:mentor_application, rejected_date: Time.now - 1.day, approved_date: Time.now)
      application.rejected?.should eq false
    end
  end

  describe 'approved?' do
    it "is true if the application has been approved" do
      application = FactoryGirl.create(:approved_mentor_application)
      application.approved?.should eq true
    end

    it "is true if the application was rejected and then approved" do
      application = FactoryGirl.create(:mentor_application, rejected_date: Time.now - 1.day, approved_date: Time.now)
      application.approved?.should eq true
    end

    it "is false if the application has been rejected" do
      application = FactoryGirl.create(:rejected_mentor_application)
      application.approved?.should eq false
    end

    it "is false if the application is pending" do
      application = FactoryGirl.create(:mentor_application)
      application.approved?.should eq false
    end

    it "is false if the application was approved and then rejected" do
      application = FactoryGirl.create(:mentor_application, rejected_date: Time.now, approved_date: Time.now - 1.day)
      application.approved?.should eq false
    end
  end

  describe "approve_me" do
    before :each do
      @user = FactoryGirl.build(:user)
    end

    it "creates an approved record" do
      application = MentorApplication.approve_me(@user)
      application.approved?.should be_true
      application.user_uuid.should == @user.uuid
    end

    it "puts placeholders in the required fields" do
      application = MentorApplication.approve_me(@user)
      application.time_commitment.should == '<pre-existing user>'
    end
  end
end






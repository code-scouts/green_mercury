require 'spec_helper'

describe MemberApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }

  it { should validate_presence_of :name }
  it { should validate_presence_of :why_you_want_to_join }
  it { should validate_presence_of :experience_level }
  it { should validate_presence_of :comfortable_learning }
  it { should validate_presence_of :time_commitment }

  it 'should return all pending applications' do
    pending = FactoryGirl.create(:member_application)
    FactoryGirl.create(:approved_member_application)
    FactoryGirl.create(:rejected_member_application)
    MemberApplication.pending.should eq [pending]
  end

  it "sets the approved date when the application is approved" do 
    application = FactoryGirl.create(:member_application)
    application.update(approved: true)
    application.approved_date.should eq Date.today
  end
end
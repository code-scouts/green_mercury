require 'spec_helper'

describe MemberApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :approved_date }

  it { should validate_presence_of :why_you_want_to_join }
  it { should validate_presence_of :experience_level }
  it { should validate_presence_of :comfortable_learning }
  it { should validate_presence_of :time_commitment }
end
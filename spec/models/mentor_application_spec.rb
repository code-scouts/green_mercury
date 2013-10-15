require 'spec_helper'

describe MentorApplication do
  it { should respond_to :user_uuid }
  it { should respond_to :content }
  it { should respond_to :approved_date }
  it { should validate_presence_of :content }
  it { should ensure_length_of(:content).is_at_most(5000) }
end
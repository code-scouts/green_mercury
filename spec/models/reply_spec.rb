require 'spec_helper'

describe Reply do
  it { should respond_to :user_uuid }
  it { should respond_to :content }
  it { should validate_presence_of :content }
  it { should belong_to :post }

  it 'should sort replies by date' do
    reply1 = FactoryGirl.create(:reply, created_at: (Date.today + 1.hour))
    reply2 = FactoryGirl.create(:reply, created_at: (Date.today + 2.hours))
    reply3 = FactoryGirl.create(:reply, created_at: Date.today)
    Reply.all.should eq [reply2, reply1, reply3]
  end
end
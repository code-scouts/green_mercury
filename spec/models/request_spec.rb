require 'spec_helper'

describe Request do 
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :content }
  it { should validate_presence_of :contact_info }
  it { should have_many(:tags) }
  it { should have_many(:concepts).through(:tags) }

  describe 'open_requests' do
    before :each do
      @user = new_mentor
      @request1 = FactoryGirl.create(:request)
      @request2 = FactoryGirl.create(:request, mentor_uuid: @user.uuid)
    end

    it 'returns any unclaimed requests' do
      Request.open_requests.should eq [@request1]
    end

    it 'returns an empty array if there are no unclaimed requests' do
      @request1.update(mentor_uuid: @user.uuid)
      Request.open_requests.should eq []
    end
  end
end
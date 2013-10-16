require 'spec_helper'

describe User do
  describe 'fetch_from_token' do
    it 'should post to janrain capture' do
      response = double
      response.should_receive(:body).and_return('{
        "result": {
          "email": "marble@stone.co"
        }
      }')
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity',
        {
          body: {
            access_token: 'the_token',
            type_name: 'user',
          }
        }
      ).and_return(response)

      user = User.fetch_from_token('the_token')
      user.should be_a(User)
      user.email.should == 'marble@stone.co'
    end
  end

  describe 'is_admin?' do
    it "should return true if the user is an admin" do
      user = FactoryGirl.build(:user)
      user.is_admin = true
      user.is_admin?.should be_true
    end

    it "should return false if the user is not an admin" do
      user = FactoryGirl.build(:user)
      user.is_admin?.should be_false
    end
  end

  describe 'is_mentor?' do
    it "should return true if the user is a mentor" do
      user = new_mentor
      user.is_mentor?.should be_true
    end

    it "should return false if the user is not a mentor" do
      user = FactoryGirl.build(:user)
      user.is_mentor?.should be_false
    end
  end

  describe 'is_member?' do
    it "should return true if the user is a member" do
      user = new_member
      user.is_member?.should be_true
    end

    it "should return false if the user is not a member" do
      user = FactoryGirl.build(:user)
      user.is_member?.should be_false
    end
  end

  describe 'is_pending?' do
    it "should return true if the user has a pending application" do
      user = FactoryGirl.build(:user)
      FactoryGirl.create(:member_application, user_uuid: user.uuid, approved_date: nil)
      user.is_pending?.should be_true
    end

    it "should return false if the user is an admin" do
      user = FactoryGirl.build(:user)
      user.is_admin = true
      user.is_pending?.should be_false
    end

    it "should return false if the user does not have a pending application" do
      user = FactoryGirl.build(:user)
      user.is_pending?.should be_false
    end
  end

  describe 'is_new?' do
    it "should return true if the user is not an admin and has not submitted an application to become a member or mentor" do
      user = FactoryGirl.build(:user)
      user.is_new?.should be_true
    end

    it "should return false if the user is an admin" do
      user = FactoryGirl.build(:user)
      user.is_admin = true
      user.is_new?.should be_false
    end

    it "should return false if the user has submitted an application to become a member or mentor" do
      user = new_member
      user.is_new?.should be_false
    end
  end
end

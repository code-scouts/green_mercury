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

  describe 'is_admin? factory' do
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
    it "should be true if the user has an approved application" do 
      user = User.new 
      user.uuid = '1234'
      FactoryGirl.create(:mentor_application, user_uuid: user.uuid, approved_date: Time.now)
      user.is_mentor?.should be_true
    end

    it "should be false if the user has no approved application" do 
      user = User.new
      user.is_mentor?.should eq false
    end

    it "should be false if the user has a rejected application" do 
      user = User.new
      user.uuid = '1234'
      FactoryGirl.create(:mentor_application, user_uuid: user.uuid, rejected_date: Time.now)
      user.is_mentor?.should be_false
    end

    it "should be false if the user has an applicaton that was accepted and then rejected" do 
      user = User.new
      user.uuid = '1234'
      application = FactoryGirl.create(:mentor_application, user_uuid: user.uuid, approved_date: Time.now - 1.hour)
      application.update(:rejected_date => Time.now)
      user.is_mentor?.should be_false 
    end

    it "should be true if the user has an application that was rejected and then accepted" do 
      user = User.new
      user.uuid = '1234'
      application = FactoryGirl.create(:mentor_application, user_uuid: user.uuid, rejected_date: Time.now - 1.hour)
      application.update(:approved_date => Time.now)
      user.is_mentor?.should be_true
    end
  end

  describe 'new_mentor factory' do
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
    it "should be true if the user has an approved application" do 
      user = User.new 
      user.uuid = '1234'
      FactoryGirl.create(:member_application, user_uuid: user.uuid, approved_date: Time.now)
      user.is_member?.should be_true
    end

    it "should be false if the user has no approved application" do 
      user = User.new
      user.is_member?.should eq false
    end

    it "should be false if the user has a rejected application" do 
      user = User.new
      user.uuid = '1234'
      FactoryGirl.create(:member_application, user_uuid: user.uuid, rejected_date: Time.now)
      user.is_member?.should be_false
    end

    it "should be false if the user has an applicaton that was accepted and then rejected" do 
      user = User.new
      user.uuid = '1234'
      application = FactoryGirl.create(:member_application, user_uuid: user.uuid, approved_date: Time.now - 1.hour)
      application.update(:rejected_date => Time.now)
      user.is_member?.should be_false 
    end

    it "should be true if the user has an application that was rejected and then accepted" do 
      user = User.new
      user.uuid = '1234'
      application = FactoryGirl.create(:member_application, user_uuid: user.uuid, rejected_date: Time.now - 1.hour)
      application.update(:approved_date => Time.now)
      user.is_member?.should be_true
    end
  end

  describe 'new_member factory' do
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

  describe "fetch_from_uuid" do
    it "should initialize a User instance if the uuid exists" do
      response = double
      response.should_receive(:body).and_return('{
        "result": {
          "email": "granite@stone.co"
        }
      }')
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity',
        {
          body: {
            uuid: 'the-uuid',
            type_name: 'user',
            client_id: 'fakeclientidfortests',
            client_secret: 'fakeclientsecretfortests',
          }
        }
      ).and_return(response)

      user = User.fetch_from_uuid('the-uuid')
      user.should be_a(User)
      user.email.should == 'granite@stone.co'
    end

    it "should return nil if the uuid doesn't exist" do
      response = double
      response.should_receive(:body).and_return('{
        "code": 310,
        "error": "record_not_found",
        "error_description": "record not found",
        "stat": "error"
      }')
      HTTParty.should_receive(:post).and_return(response)
      user = User.fetch_from_uuid('nonexistent-uuid')
      user.should be_nil
    end

    it "should puke if there is some unexpected error response" do
      response = double
      response.should_receive(:body).exactly(2).times.and_return('{
        "code": 200,
        "error": "invalid_argument",
        "error_description": "you did something terrible",
        "stat": "error"
      }')
      HTTParty.should_receive(:post).and_return(response)
      lambda {User.fetch_from_uuid('wacky-times')}.should raise_error(StandardError)
    end
  end

  describe 'public and private attributes' do
    it 'should allow access to public attributes' do
      user = User.from_hash({
        'display' => {
          "email" => "false",
          "displayName" => "true",
          "aboutMe" => "true",
        },
        "displayName" => "Jason Grlicky",
        "aboutMe" => "wireframez",
      })

      user.display_name.should == 'Jason Grlicky'
      user.about_me.should == 'wireframez'
    end

    it 'should hide private attributes' do
      user = User.from_hash({
        'display' => {
          "email" => "false",
          "displayName" => "false",
          "aboutMe" => "false",
        },
        "displayName" => "Karli",
        "aboutMe" => "real-time embedded programming",
      })

      user.display_name.should == '<hidden>'
      user.about_me.should == '<hidden>'
    end
  end

  describe 'profile photo' do
    it "should show the 'normal' profile photo if present" do
      user = User.from_hash({
        'display' => {
          "email" => "false",
          "displayName" => "false",
          "aboutMe" => "false",
        },
        "displayName" => "Shawna Scott",
        "aboutMe" => "Learnin'",
        'photos' => [
          {'type' => 'normal', 'value' => 'thisone'},
          {'type' => 'small', 'value' => 'notthisone'},
        ],
      })

      user.profile_photo_url.should == 'thisone'
    end

    it "should return nil if there's no 'normal' photo" do
      user = User.from_hash({
        "displayName" => "Michelle Rowley",
        "aboutMe" => "Respect my authoritah",
        'photos' => [
          {'type' => 'small', 'value' => 'notthisone'},
          {'type' => 'enormous', 'value' => 'notthisoneeither'},
        ],
      })

      user.profile_photo_url.should be_nil
    end
  end
end

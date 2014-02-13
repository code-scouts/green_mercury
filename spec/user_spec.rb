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

    it 'should raise something useful if the token is expired' do
      response = double
      response.should_receive(:body).and_return('{
        "request_id":"h7yyk55jjnc39bw2",
        "code":414,
        "error_description":"access_token expired",
        "error":"access_token_expired",
        "stat":"error"
      }')
      HTTParty.should_receive(:post).and_return(response)

      lambda { User.fetch_from_token('bellbottoms') }.
        should raise_error(AccessTokenExpired)
    end

    it 'should puke something debuggable if there is an error response' do
      error_json = '{
        "code": 500,
        "error_description": "A cataclysm occurred",
        "error": "cataclysm_error",
        "stat": "error"
      }'
      response = double
      response.should_receive(:body).exactly(2).times.and_return(error_json)
      HTTParty.should_receive(:post).and_return(response)

      lambda { User.fetch_from_token('tunguska') }.
        should raise_error(StandardError, error_json)
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

  describe "accept code of conduct" do
    it "should send an update to Capture" do
      Date.stub(:today).and_return(Date.new(2013, 12, 30))
      user = new_member
      response = double
      response.should_receive(:body).and_return('{
        "stat": "ok"
      }')
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity.update',
        {
          body: {
            uuid: user.uuid,
            type_name: 'user',
            client_id: 'fakeclientidfortests',
            client_secret: 'fakeclientsecretfortests',
            attribute_name: 'coc_accepted_date',
            value: '"2013-12-30"',
          }
        }
      ).and_return(response)

      user.accept_code_of_conduct
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

  describe "fetch_from_uuids" do
    it "should return a hash of uuids and users" do
      response = double
      response.should_receive(:body).and_return('{
        "results": [{
          "uuid": "the-uuid",
          "email": "granite@stone.co"
        }]
      }')
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity.find',
        {
          body: {
            filter: "uuid='the-uuid'",
            type_name: 'user',
            client_id: 'fakeclientidfortests',
            client_secret: 'fakeclientsecretfortests',
          }
        }
      ).and_return(response)

      users = User.fetch_from_uuids(['the-uuid'])
      users['the-uuid'].should be_a(User)
      users['the-uuid'].email.should == 'granite@stone.co'
    end

    it "should return an empty array if no uuids are passed in" do
      users = User.fetch_from_uuids([])
      users.should eq ({})
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

  describe 'events' do
    before do
      @event1 = FactoryGirl.create(:event, title: 'Event 1')
      @event2 = FactoryGirl.create(:event, title: 'Event 2')
      @user = FactoryGirl.build(:user)
      @event1.event_rsvps.create(user_uuid: @user.uuid)
    end

    it 'should return all events the user has RSVPd to' do
      @user.events.should eq [@event1]
    end

    it 'should not return any events that have already occurred' do
      Date.stub(:today).and_return(Date.yesterday - 1.day)
      event3 = FactoryGirl.create(:event, title: 'Event 3', date: Date.today)
      Date.unstub(:today)
      event3.event_rsvps.create(user_uuid: @user.uuid)
      @user.events.should eq [@event1]
    end
  end

  describe 'events_without_rsvp' do
    before do
      @event1 = FactoryGirl.create(:event, title: 'Event 1')
      @event2 = FactoryGirl.create(:event, title: 'Event 2')
      @user = FactoryGirl.build(:user)
      @event1.event_rsvps.create(user_uuid: @user.uuid)
    end

    it 'should return all events the user has not RSVPd to' do
      @user.events_without_rsvp.should eq [@event2]
    end

    it 'should not return any events that have already occurred' do
      Date.stub(:today).and_return(Date.yesterday - 1.day)
      event3 = FactoryGirl.create(:event, title: 'Event 3', date: Date.today)
      Date.unstub(:today)
      @user.events_without_rsvp.should eq [@event2]
    end
  end

  describe 'organizer?' do
    before do
      @event = FactoryGirl.create(:event)
      @user = FactoryGirl.build(:user)
    end

    it 'is true if the user is an organizer of the event' do
      @event.event_organizers.create(user_uuid: @user.uuid)
      @user.organizer?(@event).should be_true
    end

    it 'is false if the user is not an organizer of the event' do
      @user.organizer?(@event).should be_false
    end
  end

  describe 'acquire_token' do
    it 'should post to janrain capture' do
      mock_response = double
      mock_response.should_receive(:body).and_return('{
        "access_token": "ofmyaffection",
        "refresh_token": "insertcoin"
      }')
      HTTParty.should_receive(:post).
        with('https://codescouts.janraincapture.test.host/oauth/token', {body:{
          code: 'scouts',
          grant_type: 'authorization_code',
          redirect_uri: 'https://codescouts.janraincapture.test.host',
          client_id: 'fakeclientidfortests',
          client_secret: 'fakeclientsecretfortests',
        }}).and_return(mock_response)

      (access_token, refresh_token) = User.acquire_token('scouts')
      access_token.should eq 'ofmyaffection'
      refresh_token.should eq 'insertcoin'
    end
  end

  describe 'refresh_token' do
    it 'should post to janrain capture' do
      mock_response = double
      mock_response.should_receive(:body).and_return('{
        "access_token": "ofmyaffection",
        "refresh_token": "insertcoin"
      }')
      HTTParty.should_receive(:post).
        with('https://codescouts.janraincapture.test.host/oauth/token', {body:{
          refresh_token: 'fresssh_attire',
          grant_type: 'refresh_token',
          redirect_uri: 'https://codescouts.janraincapture.test.host',
          client_id: 'fakeclientidfortests',
          client_secret: 'fakeclientsecretfortests',
        }}).and_return(mock_response)

      (access_token, refresh_token) = User.refresh_token('fresssh_attire')
      access_token.should eq 'ofmyaffection'
      refresh_token.should eq 'insertcoin'
    end
  end

  describe 'claimed_meeting_requests' do
    it 'returns the requests created by the member (if user is a member)' do
      user = new_member
      FactoryGirl.create(:meeting_request)
      request1 = FactoryGirl.create(:meeting_request, member_uuid: user.uuid)
      request2 = FactoryGirl.create(:meeting_request, member_uuid: user.uuid, mentor_uuid: 'mentor-uuid')
      request3 = FactoryGirl.create(:meeting_request, member_uuid: 'other-member-uuid')
      request4 = FactoryGirl.create(:meeting_request, member_uuid: 'other-member-uuid', mentor_uuid: 'mentor-uuid')
      user.claimed_meeting_requests.should eq [request2]
    end

    it 'returns the requests claimed by the mentor (if user is a mentor)' do
      user = new_mentor
      request1 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid')
      request2 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid', mentor_uuid: user.uuid)
      request4 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid', mentor_uuid: 'mentor-uuid')
      user.claimed_meeting_requests.should eq [request2]
    end
  end

  describe 'open_meeting_requests' do
    it 'returns any unclaimed requests user has created (if user is a member)' do
      user = new_member
      request1 = FactoryGirl.create(:meeting_request, member_uuid: user.uuid)
      request2 = FactoryGirl.create(:meeting_request, member_uuid: user.uuid, mentor_uuid: 'mentor-uuid')
      request3 = FactoryGirl.create(:meeting_request, member_uuid: 'other-member-uuid')
      request4 = FactoryGirl.create(:meeting_request, member_uuid: 'other-member-uuid', mentor_uuid: 'mentor-uuid')
      user.open_meeting_requests.should eq [request1]
    end

    it 'returns all unclaimed requests (if user is a mentor)' do
      user = new_mentor
      request1 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid')
      request2 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid', mentor_uuid: user.uuid)
      request4 = FactoryGirl.create(:meeting_request, member_uuid: 'member-uuid', mentor_uuid: 'mentor-uuid')
      user.open_meeting_requests.should eq [request1]
    end
  end
end




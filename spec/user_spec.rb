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
      users.should eq []
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
      Date.stub(:today).and_return(Date.yesterday)
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
      Date.stub(:today).and_return(Date.yesterday)
      event3 = FactoryGirl.create(:event, title: 'Event 3', date: Date.today)
      Date.unstub(:today)
      @user.events_without_rsvp.should eq [@event2]
    end
  end
end




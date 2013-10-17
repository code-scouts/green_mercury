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
          grant_type: 'code',
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
end

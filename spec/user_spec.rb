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

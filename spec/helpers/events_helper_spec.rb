require 'spec_helper'

describe EventsHelper do
  describe "meetup_login_url" do
    it "should be right" do
      meetup_login_url.should == 'https://secure.meetup.com/oauth2/authorize?'\
                                 'client_id=Thisisnotreal&response_type=code&'\
                                 'redirect_uri=http://test.host/events/get_token'
    end
  end

  describe "exchange_code_for_token" do
    it "should post to meetup.com" do
      response = double
      response.should_receive(:body).and_return('{"access_token":"neptunecity"}')
      HTTParty.should_receive(:post).with(
        'https://secure.meetup.com/oauth2/access',
        {
          body: {
            client_id: 'Thisisnotreal',
            client_secret: 'Thiswillnotwork',
            grant_type: 'authorization_code',
            redirect_uri: 'http://test.host/events/get_token',
            code: 'blue iguana',
          }
        }
      ).and_return(response)

      exchange_code_for_token('blue iguana').should == 'neptunecity'
    end
  end

  describe "rsvp_to_event" do
    it "should post to meetup.com" do
      response = double
      response.should_receive(:body).and_return('{"rsvp":"yes"}')
      HTTParty.should_receive(:post).with(
        'https://api.meetup.com/2/rsvp',
        {
          body: {
            access_token: 'doodeedootdoo',
            event_id: 'pjharvey',
            rsvp: 'yes',
          }
        }
      ).and_return response

      rsvp_to_event('pjharvey', 'doodeedootdoo')
    end

    it "should raise an exception if unauthorized" do
      response = double
      response.should_receive(:body).and_return('{"code":"not_authorized"}')
      HTTParty.should_receive(:post).and_return response

      lambda {rsvp_to_event('pjharvey', 'doodeedootdoo')}.should raise_error(NeedNewToken)
    end
  end

  describe 'get events' do
    it "should post to meetup.com and massage the results" do
      response = double
      response.should_receive(:body).and_return('{"results":[
        {
          "time":1377829800000,
          "name":"hacknite",
          "event_url":"https://meetup.com/Pdxcodescouts/1234",
          "self":{
            "rsvp": {"response": "yes"}
          },
          "id":"rummaging"
        },
        {
          "time":1378429200000,
          "name":"hacknite 2: the hackening",
          "event_url":"https://meetup.com/Pdxcodescouts/4321",
          "self":{},
          "id":"contagious"
        }
      ]}')
      HTTParty.should_receive(:get).with('https://api.meetup.com/2/events', {query: {
        group_urlname: 'Portland-Code-Scouts',
        access_token: 'waaaaar',
        fields: 'self',
      }}).and_return(response)

      get_events('waaaaar').should == [
        {
          time: 'Thursday, 29 Aug 7:30 PM',
          name: 'hacknite',
          url: 'https://meetup.com/Pdxcodescouts/1234',
          going: true,
          id: 'rummaging',
        },
        {
          time: 'Thursday, 5 Sep 6:00 PM',
          name: 'hacknite 2: the hackening',
          url: 'https://meetup.com/Pdxcodescouts/4321',
          going: false,
          id: 'contagious',
        }
      ]
    end

    it "should raise an exception if it needs a new token" do
      response = double
      response.should_receive(:body).and_return('{"code":"not_authorized"}')
      HTTParty.should_receive(:get).and_return(response)

      lambda {get_events('peoplelikeyou')}.should raise_error(NeedNewToken)
    end
  end
end

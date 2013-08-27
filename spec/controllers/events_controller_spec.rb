require 'spec_helper'

describe EventsController do
  before :each do
    @user = FactoryGirl.build :user
    controller.stub current_user: @user
  end

  describe 'index' do
  	it 'should request meetup auth if no token exists' do
      controller.should_not receive(:get_events)
	  	get :index
      response.should be_redirect
      response.headers['Location'].should include('meetup.com/oauth2/')
	  end

    it 'should request new auth if token is expired' do
      @user.meetup_token = 'asdf1234'
      controller.should receive(:get_events).and_raise(NeedNewToken)
      get :index
      response.should be_redirect
      response.headers['Location'].should include('meetup.com/oauth2/')
    end

    it 'should list events for the current user' do
      @user.meetup_token = 'asdf1234'
      controller.should receive(:get_events).and_return(['event 1', 'event 2'])
      get :index
      response.should be_ok
      controller.instance_variable_get(:@events).should == ['event 1', 'event 2']
    end
  end

  describe "rsvp" do
    it 'should request new auth if token is expired' do
      @user.meetup_token = 'asdf1234'
      controller.should receive(:rsvp_to_event).and_raise(NeedNewToken)
      get :rsvp, id: 'aoeu'

      response.should be_redirect
      response.headers['Location'].should include('meetup.com/oauth2/')
    end

    it "should rsvp and then redirect to the index" do
      @user.meetup_token = 'asdf1234'
      controller.should receive(:rsvp_to_event).with('eventid', 'asdf1234')
      get :rsvp, id: 'eventid'

      response.should be_redirect
      response.headers['Location'].should == 'http://test.host/events'
    end
  end
end

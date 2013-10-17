require 'spec_helper'

describe SessionController do
  describe 'acquire a session' do
    it 'should get a token and put it in the session' do
      User.should_receive(:acquire_token).with('scouts').
        and_return(['ofmyaffection', 'insertcoin'])
      post :acquire_session, code: 'scouts', format: :json
      response.should be_ok
      session[:access_token].should eq "ofmyaffection"
      session[:refresh_token].should eq "insertcoin"
    end
  end

  describe 'log out' do
    it 'should clear the session cookie' do
      session[:access_token] = 'my spoon is too big'
      session[:refresh_token] = 'I am a banana'
      User.stub :fetch_from_token
      post :logout
      response.should be_redirect
      response.header['Location'].should eq 'http://test.host/'
      session[:access_token].should be_nil
      session[:refresh_token].should be_nil
    end
  end
end

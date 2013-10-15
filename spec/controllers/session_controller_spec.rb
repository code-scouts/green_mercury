require 'spec_helper'

describe SessionController do
  describe 'acquire a session' do
    it 'should set a session cookie' do
      User.should_receive(:fetch_from_token).with('asdf').and_return(
        "this is a user, honest")
      post :acquire_session, access_token: 'asdf', format: :json
      response.should be_ok
      session[:user].should == "this is a user, honest"
    end
  end

  describe 'log out' do
    it 'should clear the session cookie' do
      session[:user] = new_member
      post :logout
      response.should be_redirect
      response.header['Location'].should == 'http://test.host/'
      session[:user].should be_nil
    end
  end
end

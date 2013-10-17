require 'spec_helper'

describe SessionController do
  describe 'acquire a session' do
    it 'should get a token and put it in the session' do
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
      post :logout
      response.should be_redirect
      response.header['Location'].should eq 'http://test.host/'
      session[:access_token].should be_nil
      session[:refresh_token].should be_nil
    end
  end
end

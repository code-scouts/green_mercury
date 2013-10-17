require 'spec_helper'

describe ApplicationController do
  describe 'current_user' do
    it 'should fetch the user from the access_token in the session' do
      session[:access_token] = 'thenakedtruth'
      user = User.new
      User.should_receive(:fetch_from_token).
        with('thenakedtruth').and_return(user)

      controller.current_user.should eq user
    end

    it 'should return nil if the session has no access_token' do
      controller.current_user.should be_nil
    end

    it 'should be memoized' do
      session[:access_token] = 'suchgreatheights'
      User.should_not_receive(:fetch_from_token)
      user = User.new
      controller.instance_variable_set(:@user, user)
      assert controller.current_user.eql?(user), "didn't use memoized value"
    end

    it 'should refresh an expired access_token' do
      session[:access_token] = 'acidwashjeans'
      session[:refresh_token] = 'prefadedjeans'
      User.should_receive(:fetch_from_token).and_raise(AccessTokenExpired)
      User.should_receive(:refresh_token).with('prefadedjeans').
        and_return(['skinnyjeans', 'utilikilt'])
      User.should_receive(:fetch_from_token).
        with('skinnyjeans').and_return(User.new)

      controller.current_user

      session[:access_token].should eq 'skinnyjeans'
      session[:refresh_token].should eq 'utilikilt'
      controller.instance_variable_get(:@fresh_access_token).should eq 'skinnyjeans'
    end
  end
end

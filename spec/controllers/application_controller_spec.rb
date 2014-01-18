require 'spec_helper'

describe ApplicationController do
  before do
    ApplicationController.send :public, :new_applicant
    ApplicationController.send :public, :pending_applicant
  end

  context "admin" do
    it "can view the page" do 
      user = FactoryGirl.build(:user)
      user.is_admin = true
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false  
    end
  end

  context "member" do 
    it "can view the page" do 
      user = new_member
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false
    end
  end

  context "mentor" do 
    it "can view the page" do 
      user = new_mentor
      controller.stub(:current_user) { user }
      controller.new_applicant
      controller.pending_applicant
      controller.performed?.should be_false
    end
  end

  context "petition submitted (not yet approved)" do 
    it "is redirected to another page" do 
      user = FactoryGirl.build(:user)
      FactoryGirl.create(:mentor_application, user_uuid: user.uuid, approved_date: nil)
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/new_applications/show')
      controller.pending_applicant
    end    
  end

  context "no petition submitted" do 
    it "is redirected to another page" do 
      user = FactoryGirl.build(:user)
      controller.stub(:current_user) { user }
      controller.should_receive(:redirect_to).with('/new_applications/index')
      controller.new_applicant
    end
  end

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

  describe 'update_last_logged_in' do   
    it 'should post to the janrain capture current time as the last_logged_in time' do 
      user = new_mentor
      controller.stub(:current_user) { user }
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity.update',
        {
          body: {
            uuid: user.uuid,
            type_name: 'user',
            attributes: {last_logged_in: "#{Time.now}"},
            client_id: 'fakeclientidfortests',
            client_secret: 'fakeclientsecretfortests'
          }
        }
      )
      controller.update_last_logged_in
    end

    it 'should return nil there is no user' do
      controller.update_last_logged_in.should be_nil
    end
  end
end

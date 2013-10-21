require 'spec_helper'

describe ProfileController do
  describe 'view the edit page' do
    it 'should set the appropriate Capture Widget Screen' do
      get :edit
      controller.instance_variable_get(:@screen_to_render).should == 'editProfile'
    end
  end

  describe 'view a public profile' do
    it 'should return a 404 if the uuid is invalid' do
      User.should_receive(:fetch_from_uuid).with('jason-grlicky').and_return nil
      lambda { get :show, uuid: 'jason-grlicky' }.
        should raise_error(ActionController::RoutingError)
    end

    it "should show the user's public attributes" do
      user = User.new
      user.should_receive(:display_name).and_return('Andrew Lorente')
      user.should_receive(:about_me).and_return('technical lead')
      user.should_receive(:profile_photo_url).and_return('CLOUDFRONT')
      User.should_receive(:fetch_from_uuid).and_return(user)
      get :show, uuid: 'andrew-lorente'
      controller.instance_variable_get(:@display_name).should == 'Andrew Lorente'
      controller.instance_variable_get(:@about_me).should == 'technical lead'
      controller.instance_variable_get(:@profile_photo_url).should == 'CLOUDFRONT'
    end
  end
end

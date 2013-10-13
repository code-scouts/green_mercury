require 'spec_helper'

describe ProfileController do
  describe 'view the edit page' do
    it 'should set the appropriate Capture Widget Screen' do
      get :edit
      controller.instance_variable_get(:@screen_to_render).should == 'editProfile'
    end
  end
end

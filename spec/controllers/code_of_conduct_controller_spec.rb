require 'spec_helper'

describe CodeOfConductController do

  describe "accepting the code of conduct" do
    before do
      @user = new_member
      controller.stub(:current_user).and_return(@user)
    end

    it "should store the acceptance on the capture record" do
      @user.should_receive(:accept_code_of_conduct)
      post :accept
      response.should be_redirect
    end
  end

end

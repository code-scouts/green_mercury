require 'spec_helper'

describe ConfirmationsController do

  describe "GET 'flash'" do
    it "returns http success" do
      get 'flash'
      response.should be_success
    end
  end

end

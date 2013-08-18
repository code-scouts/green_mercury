require 'spec_helper'

describe User do
  describe "has_password?" do
    describe "does not has password" do
      before :each do
        @user = FactoryGirl.build :social_user
      end

      it "should not have password" do
        @user.has_password?.should be_false
      end
    end
  end

  describe "create" do
    describe "blank email" do
      it "is nil, not empty string" do
        user = User.create!
        user.email.should be_nil
      end
    end
  end
end

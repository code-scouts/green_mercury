require 'spec_helper'

describe UserMailer do 
  describe "miss_you" do 
    let(:user) { new_mentor }
    let(:mail) { UserMailer.miss_you(user) }

    it "sends user miss you email" do 
      mail.subject.should eq "We miss you!"
      mail.to.should eq([user.email])
    end
  end
end
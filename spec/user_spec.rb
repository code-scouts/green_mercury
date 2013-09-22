require 'spec_helper'

describe User do
  describe 'fetch_from_token' do
    it 'should post to janrain capture' do
      response = double
      response.should_receive(:body).and_return('{
        "result": {
          "email": "marble@stone.co"
        }
      }')
      HTTParty.should_receive(:post).with(
        'https://codescouts.janraincapture.test.host/entity',
        {
          body: {
            access_token: 'the_token',
            type_name: 'user',
          }
        }
      ).and_return(response)

      user = User.fetch_from_token('the_token')
      user.should be_a(User)
      user.email.should == 'marble@stone.co'
    end
  end
end

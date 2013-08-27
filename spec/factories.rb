FactoryGirl.define do
  factory :social_user, class: User do
  	rpx_identifier 'http://twitter.com/account/profile?user_id=123456'
  end

  factory :user, class: User
end

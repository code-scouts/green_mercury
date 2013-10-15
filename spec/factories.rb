FactoryGirl.define do
  factory :member_application do 
    user_uuid '1'
    content 'about me'
    approved_date Date.today
  end

  factory :mentor_application do 
    user_uuid '1'
    content 'about me'
    approved_date Date.today
  end

  factory :user do
    sequence(:uuid) { |n| "user#{n}"} 
  end
end

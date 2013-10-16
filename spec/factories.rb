FactoryGirl.define do
  factory :member_application do 
    user_uuid '1'
    why_you_want_to_join "I don't know"
    experience_level "Advanced"
    comfortable_learning 2
    time_commitment 'All day'
    approved_date Date.today
  end

  factory :mentor_application do 
    user_uuid '1'
    name 'Bob'
    contact 'email'
    geography 'Portland'
    hear_about 'website'
    motivation 'Very'
    time_commitment 'all day'
    mentor_one_on_one 'very interested'
    mentor_group 'very interested'
    mentor_online 'very interested'
    volunteer_events 'very interested'
    volunteer_teams 'very interested'
    volunteer_solo 'very interested'
    volunteer_technical 'very interested'
    volunteer_online 'very interested'
    approved_date Date.today
  end

  factory :user do
    sequence(:uuid) { |n| "user#{n}"} 
  end
end

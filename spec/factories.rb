FactoryGirl.define do
  factory :member_application do 
    name 'Bob'
    sequence(:user_uuid) { |n| "member#{n}" }
    why_you_want_to_join "I don't know"
    experience_level "Advanced"
    comfortable_learning 2
    time_commitment 'All day'

    factory :approved_member_application do 
      approved_date Date.today
    end
    
  end

  factory :mentor_application do 
    sequence(:user_uuid) { |n| "mentor#{n}" }
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

    factory :approved_mentor_application do
      approved_date Date.today
    end
  end

  factory :user do
    sequence(:uuid) { |n| "user#{n}"} 

    factory :admin do 
      is_admin true
    end
  end
end

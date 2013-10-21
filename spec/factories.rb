FactoryGirl.define do
  factory :event do
    title 'Awesome Party'
    description 'We will do crazy stuff together'
    location '701 E Burnside St  Portland, OR 97214'
    date Date.tomorrow
    start_time Time.now
    end_time (Time.now + 3.hours)
  end

  factory :concept do
    name "Ruby"
  end 

  factory :concept_description do
    description "A programming language"
    concept
    user_uuid '1'
  end

  factory :user do
    uuid 'my-uuid'
    name 'Bob'
    email 'bob@example.com'
  end
end

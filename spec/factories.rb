FactoryGirl.define do
  factory :event do
    title 'Awesome Party'
    description 'We will do crazy stuff together'
    location '123 Cool St.'
    date Date.tomorrow
    start_time Time.now
    end_time (Time.now + 3.hours)
  end
end

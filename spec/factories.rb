FactoryGirl.define do
  factory :concept do
    name "Ruby"
  end 

  factory :concept_description do
    description "A programming language"
    concept
  end
end

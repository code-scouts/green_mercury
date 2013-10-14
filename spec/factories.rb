FactoryGirl.define do
  factory :concept do
    name "Ruby"
  end 

  factory :concept_content do
    content "A programming language"
    concept
  end
end

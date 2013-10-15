require 'spec_helper'

describe Concept do
  it { should have_many :concept_descriptions }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(20) }

  it 'returns the latest description' do
    concept = FactoryGirl.create(:concept)
    concept_descriptions1 = ConceptDescription.create(description: "A programming language", concept_id: concept.id)
    concept_descriptions2 = ConceptDescription.create(description: "A cool programming language", concept_id: concept.id)
    concept.latest.description.should eq "A cool programming language"
  end

  it 'returns all descriptions' do
    concept = FactoryGirl.create(:concept)
    concept_descriptions1 = ConceptDescription.create(description: "A programming language", concept_id: concept.id)
    concept_descriptions2 = ConceptDescription.create(description: "A cool programming language", concept_id: concept.id)
    concept.history.length.should eq 2
  end
end
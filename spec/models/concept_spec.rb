require 'spec_helper'

describe Concept do
  it { should have_many :concept_contents }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(20) }

  it 'returns the latest description' do
    concept = FactoryGirl.create(:concept)
    concept_contents1 = ConceptContent.create(content: "A programming language", concept_id: concept.id)
    concept_contents2 = ConceptContent.create(content: "A cool programming language", concept_id: concept.id)
    concept.latest.content.should eq "A cool programming language"
  end

  it 'returns all descriptions' do
    concept = FactoryGirl.create(:concept)
    concept_contents1 = ConceptContent.create(content: "A programming language", concept_id: concept.id)
    concept_contents2 = ConceptContent.create(content: "A cool programming language", concept_id: concept.id)
    concept.history.length.should eq 2
  end
end
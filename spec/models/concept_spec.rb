require 'spec_helper'

describe Concept do
  before do
    @concept = FactoryGirl.create(:concept)
    @concept_descriptions1 = @concept.concept_descriptions.create(description: "A programming language", user_uuid: '1')
    @concept_descriptions2 = @concept.concept_descriptions.create(description: "A cool programming language", user_uuid: '1')
  end

  it { should have_many :concept_descriptions }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(100) }
  it { should have_many :tags }

  it 'returns the latest description' do
    @concept.latest.description.should eq @concept_descriptions2.description
  end

  it 'returns all descriptions' do
    @concept.history.length.should eq 2
  end
end
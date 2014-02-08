require 'spec_helper'

describe Concept do
  it { should have_many :concept_descriptions }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(100) }
  it { should have_many :tags }

  describe "#latest" do 
    it 'returns the latest description' do
      concept = FactoryGirl.create(:concept)
      concept_description_old = concept.concept_descriptions.create(description: "A programming language", user_uuid: '1')
      concept_description_new = concept.concept_descriptions.create(description: "A cool programming language", user_uuid: '1')
      expect(concept.latest).to eq concept_description_new
    end
  end
end

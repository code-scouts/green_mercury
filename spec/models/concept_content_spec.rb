require 'spec_helper'

describe ConceptContent do
  it { should belong_to :concept }
  it { should validate_presence_of :content } 
  it { should validate_presence_of :user_uuid } 
  it { should validate_presence_of :concept_id }
end
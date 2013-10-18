require 'spec_helper'

describe ConceptDescription do
  it { should belong_to :concept }
  it { should validate_presence_of :description } 
  it { should validate_presence_of :user_uuid } 
  it { should validate_presence_of :concept }
end
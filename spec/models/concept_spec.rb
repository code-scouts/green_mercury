require 'spec_helper'

describe Concept do
  it { should have_many :concept_contents }
  it { should validate_presence_of :name }
  it { should ensure_length_of(:name).is_at_most(20) }
end
require 'spec_helper'

describe Project do   
  it { should have_many :mentor_participations }
  it { should have_many :member_participations }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should accept_nested_attributes_for :mentor_participations }
  it { should accept_nested_attributes_for :member_participations }
end


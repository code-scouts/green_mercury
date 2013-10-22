require 'spec_helper'

describe Project do 
  it { should have_many :participations }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :max_members }
  it { should validate_presence_of :max_mentors }
end
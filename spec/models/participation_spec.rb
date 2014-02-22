require 'spec_helper'

describe Participation do
  it { should validate_presence_of :role } 
end
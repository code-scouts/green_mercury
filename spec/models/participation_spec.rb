require 'spec_helper'

describe Participation do 
  it { should belong_to :project }
  it { should validate_presence_of :user_uuid }
end
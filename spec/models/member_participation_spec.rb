require 'spec_helper'

describe MemberParticipation do 
  it { should belong_to :project }
  it_behaves_like "a participation"
end

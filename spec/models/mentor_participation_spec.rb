require 'spec_helper' 

describe MentorParticipation do 
  it { should belong_to :project }
  it_behaves_like "a participation"
end
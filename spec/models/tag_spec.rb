require 'spec_helper'

describe Tag do

  it { should belong_to :tagable }
  it { should belong_to :concept }

end
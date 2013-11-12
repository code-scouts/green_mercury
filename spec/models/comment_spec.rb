require 'spec_helper'

describe Comment do 
  it { should belong_to :commentable }
  it { should have_many :comments }
  it { should ensure_length_of(:title).is_at_most(50) }
end
require 'spec_helper'

describe MeetingRequest do 
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should validate_presence_of :content }
  it { should validate_presence_of :contact_info }
  it { should have_many(:tags) }
  it { should have_many(:concepts).through(:tags) }
end
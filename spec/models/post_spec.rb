require 'spec_helper'

describe Post do
  it { should respond_to :user_uuid }
  it { should respond_to :title }
  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(100) }
  it { should respond_to :content }
  it { should validate_presence_of :content }
  it { should belong_to :project }
  it { should have_many :replies }
end
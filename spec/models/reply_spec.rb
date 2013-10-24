require 'spec_helper'

describe Reply do
  it { should respond_to :user_uuid }
  it { should respond_to :content }
  it { should validate_presence_of :content }
  it { should belong_to :post }
end
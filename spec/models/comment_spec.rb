require 'spec_helper'

describe Comment do
  it { should belong_to :commentable }
  it { should have_many :comments }
  it { should ensure_length_of(:title).is_at_most(50) }
  it { should validate_presence_of :comment }

  describe 'get_project' do
    let(:project) { FactoryGirl.create(:project_with_comment) }

    it 'returns the project that the comment belongs to' do
      project.comments.first.get_project.id.should eq project.id
    end

    it 'returns the project when the comment is threaded' do
      comment = project.comments.first.comments.create(title: "Title", comment: "Comment")
      comment.get_project.id.should eq project.id
    end
  end
end

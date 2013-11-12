class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  belongs_to :commentable, :polymorphic => true
  has_many :comments, as: :commentable 
  default_scope -> { order('created_at ASC') }
  validates :title, length: { maximum: 50 }
  validates :comment, presence: true

  def get_project
    if commentable_type === 'Project'
      self.commentable 
    else
      self.commentable.get_project
    end
  end
end

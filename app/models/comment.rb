class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  belongs_to :commentable, :polymorphic => true
  has_many :comments, as: :commentable 
  default_scope -> { order('created_at ASC') }
  validates :title, length: { maximum: 50 }
  validates :comment, presence: true
end
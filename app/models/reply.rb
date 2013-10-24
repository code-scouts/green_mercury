class Reply < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :post
  default_scope { order('created_at DESC') }
end
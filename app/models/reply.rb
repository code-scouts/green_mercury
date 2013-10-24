class Reply < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :post
end
class Post < ActiveRecord::Base
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true
  has_many :replies
end
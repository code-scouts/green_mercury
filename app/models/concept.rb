class Concept < ActiveRecord::Base
  has_many :concept_contents
  validates :name, presence: true, length: {maximum: 20}
end
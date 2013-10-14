class Concept < ActiveRecord::Base
  has_many :concept_contents, :inverse_of => :concept
  accepts_nested_attributes_for :concept_contents, allow_destroy: true
  validates :name, presence: true, length: {maximum: 20}
end
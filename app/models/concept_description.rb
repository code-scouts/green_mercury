class ConceptDescription < ActiveRecord::Base
  belongs_to :concept, :inverse_of => :concept_descriptions

  validates :description, presence: true
  validates :user_uuid, presence: true
  validates :concept, presence: true
end
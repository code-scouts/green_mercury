class ConceptContent < ActiveRecord::Base
  belongs_to :concept
  validates :content, presence: true
  validates :user_uuid, presence: true
  validates :concept_id, presence: true
end
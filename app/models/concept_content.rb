class ConceptContent < ActiveRecord::Base
  belongs_to :concept, :inverse_of => :concept_contents

  validates :content, presence: true
  # validates :user_uuid, presence: true
  validates :concept, presence: true
end
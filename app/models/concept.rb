class Concept < ActiveRecord::Base
  has_many :concept_descriptions, -> { order "created_at DESC" }, :inverse_of => :concept
  has_many :tags
  has_many :requests, :through => :tags
  accepts_nested_attributes_for :concept_descriptions, allow_destroy: true
  validates :name, presence: true, length: {maximum: 100}

  def latest 
    concept_descriptions.first
  end
end

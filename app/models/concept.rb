class Concept < ActiveRecord::Base
  has_many :concept_descriptions, :inverse_of => :concept
  accepts_nested_attributes_for :concept_descriptions, allow_destroy: true
  validates :name, presence: true, length: {maximum: 20}

  def latest 
    concept_descriptions.order("created_at DESC").first
  end

  def history
    concept_descriptions.order("created_at DESC")
  end
end
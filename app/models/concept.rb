class Concept < ActiveRecord::Base
  has_many :concept_contents, :inverse_of => :concept
  accepts_nested_attributes_for :concept_contents, allow_destroy: true
  validates :name, presence: true, length: {maximum: 20}

  def latest 
    concept_contents.order("created_at DESC").first
  end

  def history
    concept_contents.order("created_at DESC")
  end
end
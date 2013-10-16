class MemberApplication < ActiveRecord::Base
  after_update :set_approved_date

  validates :why_you_want_to_join, presence: true 
  validates :experience_level, presence: true 
  validates :comfortable_learning, presence: true 
  validates :time_commitment, presence: true 
  validates :name, presence: true

  def self.pending 
    MemberApplication.where(approved_date: nil)
  end

private 
  def set_approved_date
    if approved? && approved_date.nil?
      self.approved_date = Date.today
    end
  end
end
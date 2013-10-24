class Project < ActiveRecord::Base
  has_many :member_participations
  has_many :mentor_participations
  validates :title, presence: true
  validates :description, presence: true

  accepts_nested_attributes_for :mentor_participations
  accepts_nested_attributes_for :member_participations

  def mentor_participant?(user)
    mentor_participations.any? do |participation|
      participation.user_uuid == user.uuid
    end
  end

  def member_participant?(user)
    member_participations.any? do |participation|
      participation.user_uuid == user.uuid
    end
  end
end
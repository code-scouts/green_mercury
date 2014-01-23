class Project < ActiveRecord::Base
  has_many :member_participations
  has_many :mentor_participations
  has_many :comments, as: :commentable
  validates :title, presence: true
  validates :description, presence: true
  has_attached_file :image, styles: { medium: "250x250>", thumb: "75x75>" },
                            default_url: "default_image_:style.png"

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

  def self.available_for(user)
    participation_class = user.is_member? ? MemberParticipation : MentorParticipation
    project_ids = participation_class.where(user_uuid: nil).map(&:project_id)
    Project.where(id: [project_ids])
  end

  def self.unavailable_for(user)
    participation_class = user.is_member? ? MemberParticipation : MentorParticipation
    project_ids = participation_class.where(user_uuid: nil).map(&:project_id)
    Project.where("id not in (?)", project_ids)
  end
end
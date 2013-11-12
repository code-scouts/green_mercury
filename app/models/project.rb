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

  def self.available(user)
    if user == 'member'
      project_ids = MemberParticipation.where(user_uuid: nil).map(&:project_id)
    else
      project_ids = MentorParticipation.where(user_uuid: nil).map(&:project_id)
    end

    Project.all.keep_if { |project| project_ids.include?(project.id) }
  end

  def self.unavailable(user)
    Project.all - Project.available(user)
  end
end
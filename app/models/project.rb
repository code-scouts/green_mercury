class Project < ActiveRecord::Base
  has_many :member_participations
  has_many :mentor_participations
  has_many :comments, as: :commentable
  validates :title, presence: true
  validates :description, presence: true
  has_attached_file(:image, {
                    styles: { medium: "250x250>", thumb: "75x75>" },
                    default_url: "default_image_:style.png",
                    }.merge(PAPERCLIP_OPTIONS))
  validates_attachment_content_type :image,
    :content_type => %w(image/jpeg image/jpg image/png image/gif)

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
    project_ids = user.participation_class.unfilled.pluck(:project_id)
    Project.where(id: project_ids)
  end
end

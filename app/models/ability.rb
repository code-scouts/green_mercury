class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_admin?
      can :manage, :all

    elsif user.is_mentor? 
      can :create, Project
      can :read, MeetingRequest

      can :update, MentorParticipation do |participation|
        participation.user_uuid.nil? && !participation.project.mentor_participant?(user)
      end

      can :update, Project do |project|
        project.user_uuid == user.uuid
      end

    elsif user.is_member?
      can :manage, MeetingRequest, member_uuid: user.uuid
      can :read, MeetingRequest

      can :update, MemberParticipation do |participation|
        participation.user_uuid.nil? && !participation.project.member_participant?(user)
      end
    end

    can :participate, Project do |project|
      project.mentor_participant?(user) || project.member_participant?(user)
    end

    can :claim, MeetingRequest do |meeting_request|
      user.is_mentor? && meeting_request.mentor_uuid.nil?
    end

    can :manage, Event do |event|
      user.organizer?(event)
    end

    if !user.uuid.nil?
      can [:read, :create], Event
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.is_admin?
      can :manage, :all

    elsif user.is_mentor? 
      can :create, Project
      can :update, MentorParticipation do |participation|
        participation.user_uuid.nil? && !participation.project.mentor_participant?(user)
      end

    elsif user.is_member?
      can :update, MemberParticipation do |participation|
        participation.user_uuid.nil? && !participation.project.member_participant?(user)
      end
    end

    can :participate, Project do |project|
      project.mentor_participant?(user) || project.member_participant?(user)
    end
  end
end

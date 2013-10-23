class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_admin?
      can :manage, :all
    end

    if user.is_member?
      can :manage, Request, member_uuid: user.uuid
      can :read, Request
    end

    if user.is_mentor?
      can :read, Request
    end

    can :manage, Event do |event|
      user.organizer?(event)
    end

    if !user.uuid.nil?
      can [:read, :create], Event
    end
  end
end

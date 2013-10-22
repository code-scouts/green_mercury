class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_admin?
      can :manage, :all
    end

    can :manage, Event do |event|
      user.organizer?(event)
    end

    if !user.uuid.nil?
      can [:read, :create], Event
    end
  end
end

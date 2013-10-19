class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :manage, Event do |event|
      user.organizer?(event)
    end

    if !user.uuid.nil?
      can [:read, :create], Event
    end
  end
end
class MemberParticipationsController < ApplicationController 
  include ParticipationManager

private
  def participation_model
    MemberParticipation
  end
end
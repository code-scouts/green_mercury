class MentorParticipationsController < ApplicationController
  include ParticipationManager

private 
  def participation_model
    MentorParticipation
  end

end
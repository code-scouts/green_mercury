class ClaimMeetingRequestsController < ApplicationController
  def create
    @meeting_request = MeetingRequest.find(params[:meeting_request_id])
    unless @meeting_request.mentor_uuid.nil?
      @mentor = User.fetch_from_uuid(@meeting_request.mentor_uuid)
    end
    authorize! :claim, @meeting_request
    @meeting_request.update(mentor_uuid: current_user.uuid)
    respond_to do |format|
      format.html { redirect_to meeting_request_path(@meeting_request) }
      format.js
    end
  end
end
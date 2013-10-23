class ClaimRequestsController < ApplicationController
  def create
    @request = Request.find(params[:request_id])
    authorize! :claim, @request
    @request.update(mentor_uuid: current_user.uuid)
    respond_to do |format|
      format.html { redirect_to request_path(@request) }
      format.js
    end
  end
end
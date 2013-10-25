class MeetingRequestsController < ApplicationController
  def new
    @meeting_request = MeetingRequest.new(member_uuid: current_user.uuid)
    authorize! :create, @meeting_request
  end

  def create
    @meeting_request = MeetingRequest.new(meeting_request_params)
    authorize! :create, @meeting_request
    if @meeting_request.save
      flash[:notice] = "Request successfully created"
      redirect_to meeting_request_path @meeting_request
    else
      render 'new'
    end
  end

  def edit
    @meeting_request = MeetingRequest.find(params[:id])
    authorize! :update, @meeting_request
  end

  def update
    @meeting_request = MeetingRequest.find(params[:id])
    authorize! :update, @meeting_request
    if @meeting_request.update(meeting_request_params)
      flash[:notice] = "Request has been updated"
      redirect_to meeting_request_path(@meeting_request)
    else
      render 'edit'
    end
  end

  def index
    authorize! :read, MeetingRequest
    open_uuids = current_user.open_meeting_requests.map(&:member_uuid)
    claimed_uuids = current_user.claimed_meeting_requests.map(&:member_uuid)
    @open_users = User.fetch_from_uuids(open_uuids)
    @claimed_users = User.fetch_from_uuids(claimed_uuids)
  end

  def show
    @meeting_request = MeetingRequest.find(params[:id])
    @member = User.fetch_from_uuid(@meeting_request.member_uuid)
    unless @meeting_request.mentor_uuid.nil?
      @mentor = User.fetch_from_uuid(@meeting_request.mentor_uuid)
    end
  end

  def destroy
    @meeting_request = MeetingRequest.find(params[:id])
    authorize! :destroy, @meeting_request
    @meeting_request.destroy
    flash[:notice] = "Request has been deleted"
    redirect_to meeting_requests_path
  end

private

  def meeting_request_params
    params.require(:meeting_request).permit(:title, :content, :contact_info, :member_uuid)
  end
end
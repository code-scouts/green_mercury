class RequestsController < ApplicationController
  def new
    @request = Request.new(member_uuid: current_user.uuid)
    authorize! :create, @request
  end

  def create
    @request = Request.new(request_params)
    authorize! :create, @request
    if @request.save
      flash[:notice] = "Request successfully created"
      redirect_to request_path @request
    else
      render 'new'
    end
  end

  def edit
    @request = Request.find(params[:id])
    authorize! :update, @request
  end

  def update
    @request = Request.find(params[:id])
    authorize! :update, @request
    if @request.update(request_params)
      flash[:notice] = "Request has been updated"
      redirect_to request_path(@request)
    else
      render 'edit'
    end
  end

  def index
    authorize! :read, Request
    open_uuids = current_user.open_requests.map { |open_request| open_request.member_uuid }
    claimed_uuids = current_user.claimed_requests.map { |claimed_request| claimed_request.member_uuid }
    @open_users = User.fetch_from_uuids(open_uuids)
    @claimed_users = User.fetch_from_uuids(claimed_uuids)
  end

  def show
    @request = Request.find(params[:id])
    @member = User.fetch_from_uuid(@request.member_uuid)
    unless @request.mentor_uuid.nil?
      @mentor = User.fetch_from_uuid(@request.mentor_uuid)
    end
  end

  def destroy
    @request = Request.find(params[:id])
    authorize! :destroy, @request
    @request.destroy
    flash[:notice] = "Request has been deleted"
    redirect_to requests_path
  end

  private
  def request_params
    params.require(:request).permit(:title, :content, :contact_info, :member_uuid)
  end
end
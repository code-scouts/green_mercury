class RequestsController < ApplicationController
  def new
    @request = Request.new(member_uuid: current_user.uuid)
  end

  def create
    @request = Request.new(request_params)
    if @request.save
      flash[:notice] = "Request successfully created"
      redirect_to requests_path
    else
      render 'new'
    end
  end

  def edit
    @request = Request.find(params[:id])
  end

  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      flash[:notice] = "Request has been updated"
      redirect_to requests_path
    else
      render 'edit'
    end
  end

  def index
    @requests = Request.all
  end


  private
  def request_params
    params.require(:request).permit(:title, :content, :contact_info, :member_uuid)
  end
end
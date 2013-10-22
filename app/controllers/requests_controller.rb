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

  private
  def request_params
    params.require(:request).permit(:title, :content, :contact_info, :member_uuid)
  end
end
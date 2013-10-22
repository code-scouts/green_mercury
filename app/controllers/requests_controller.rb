class RequestsController < ApplicationController
  def new
    @request = Request.new
  end
end
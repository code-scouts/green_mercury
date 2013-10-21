require 'user'

class SessionController < ApplicationController
  skip_before_filter :new_applicant
  skip_before_filter :pending_applicant
  
  def acquire_session
    respond_to do |format|
      params.require :code
      code = params[:code]

      access_token, refresh_token = User.acquire_token(code)
      session[:access_token] = access_token
      session[:refresh_token] = refresh_token

      format.json do
        render json: {access_token: session[:access_token]}
      end
    end
  end

  def logout
    session[:access_token] = nil
    session[:refresh_token] = nil
    redirect_to root_path
  end
end

require 'user'

class SessionController < ApplicationController
  def acquire_session
    respond_to do |format|
      params.require :code
      code = params[:code]

      response = HTTParty.post(CAPTURE_URL+'/oauth/token', {body:{
        code: code,
        grant_type: 'authorization_code',
        redirect_uri: CAPTURE_URL,
        client_id: CAPTURE_OWNER_CLIENT_ID,
        client_secret: CAPTURE_OWNER_CLIENT_SECRET,
      }})

      body = JSON.parse(response.body)
      session[:access_token] = body['access_token']
      session[:refresh_token] = body['refresh_token']

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

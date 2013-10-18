class ApplicationController < ActionController::Base
  #this ugly hack lets us have link_to available without overwriting
  #ActionController::Base#url_for.
  alias_method :original_url_for, :url_for
  include ActionView::Helpers::UrlHelper
  alias_method :url_for, :original_url_for

  helper_method :user_signed_in?
  helper_method :current_user
  before_filter :load_janrain_facts
  before_filter :current_user

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  def current_user
    return unless session[:access_token]

    begin
      @user ||= User.fetch_from_token(session[:access_token])
    rescue AccessTokenExpired
      access_token, refresh_token = User.refresh_token(session[:refresh_token])
      session[:access_token] = access_token
      session[:refresh_token] = refresh_token
      @fresh_access_token = access_token
      @user = User.fetch_from_token(access_token)
    end
  end

  def user_signed_in?
    ! current_user.nil?
  end

  protected

  def load_janrain_facts
    @janrain_client_id = CAPTURE_OWNER_CLIENT_ID
    @janrain_app_id = CAPTURE_APP_ID
    @janrain_rpx_url = RPX_URL
    @janrain_capture_url = CAPTURE_URL
    @flow_version = FLOW_VERSION
    @flow_name = 'signinFlow'
    @screen_to_render = if params[:verification_code].present?
      'verifyEmail'
    elsif params[:code].present?
      'resetPasswordRequestCode'
    end
  end
end

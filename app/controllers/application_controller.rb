class ApplicationController < ActionController::Base
  #this ugly hack lets us have link_to available without overwriting
  #ActionController::Base#url_for.
  alias_method :original_url_for, :url_for
  include ActionView::Helpers::UrlHelper
  alias_method :url_for, :original_url_for
  include ApplicationHelper

  helper_method :user_signed_in?, :current_user
  before_filter :load_janrain_facts
  before_filter :new_applicant
  before_filter :pending_applicant
  # So, current_user is a helper method, not a filter. We're running it
  # here as a before_filter so that @fresh_access_token can be set by the
  # time template rendering starts. This is a hack and should be undone if
  # current_user or user_signed_in? is being called for some legitimate
  # reason on each page load.
  before_filter :current_user

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :select_a_sponsor
  
  def select_a_sponsor
    @sponsor = sponsors.sample
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

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

  def associated_users(collection)
    user_uuids = collection.map do |entry|
      entry.user_uuid
    end
    User.fetch_from_uuids(user_uuids)
  end

  def update_last_logged_in
    return unless current_user
    current_user.update_attribute(last_logged_in: "#{Time.now}") 
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

  def new_applicant
    if user_signed_in? && current_user.is_new?
      redirect_to new_application_path
    end
  end

  def pending_applicant
    if user_signed_in? && current_user.is_pending?
      redirect_to new_applications_show_path
    end
  end
end

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

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  before_filter :select_a_sponsor
  def select_a_sponsor
    @sponsor = sponsors.sample
  end

  def current_user
    session[:user]
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

  protected

  def load_janrain_facts
    @janrain_login_client_id = CAPTURE_LOGIN_CLIENT_ID
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

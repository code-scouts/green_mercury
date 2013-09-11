class ApplicationController < ActionController::Base
  #this ugly hack lets us have link_to available without overwriting
  #ActionController::Base#url_for.
  alias_method :original_url_for, :url_for
  include ActionView::Helpers::UrlHelper
  alias_method :url_for, :original_url_for
  helper_method :user_signed_in?

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  def current_user
    nil
  end

  def user_signed_in?
    ! current_user.nil?
  end
end

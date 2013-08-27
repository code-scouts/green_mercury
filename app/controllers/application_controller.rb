class ApplicationController < ActionController::Base
  #this ugly hack lets us have link_to available without overwriting
  #ActionController::Base#url_for.
  alias_method :original_url_for, :url_for
  include ActionView::Helpers::UrlHelper
  alias_method :url_for, :original_url_for

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  before_filter :tell_users_to_have_an_email

  def tell_users_to_have_an_email
    if user_signed_in? && current_user.email.blank?
      flash[:alert] = "Please #{link_to('edit your profile',
        edit_user_registration_path)} and add an email address.".html_safe
    end
  end
end

class ApplicationController < ActionController::Base
  include ActionView::Helpers::UrlHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :tell_users_to_have_an_email

  def tell_users_to_have_an_email
    if user_signed_in? && current_user.email.blank?
      flash[:alert] = "Please #{link_to('edit your profile',
        edit_user_registration_path)} and add an email address.".html_safe
    end
  end
end

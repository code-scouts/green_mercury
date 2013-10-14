require 'user'

class ProfileController < ApplicationController
  def edit
    @screen_to_render = 'editProfile'
  end

  def show
    profile_user = User.fetch_from_uuid(params[:uuid])
    raise ActionController::RoutingError.new('Not Found') unless profile_user

    @display_name = profile_user.display_name
    @about_me = profile_user.about_me
    @profile_photo_url = profile_user.profile_photo_url
  end
end

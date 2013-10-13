require 'user'

class ProfileController < ApplicationController
  def edit
    @screen_to_render = 'editProfile'
  end
end

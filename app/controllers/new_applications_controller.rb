class NewApplicationsController < ApplicationController
  skip_before_filter :new_applicant?
  def show 
    
  end
end
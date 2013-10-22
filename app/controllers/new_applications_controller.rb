class NewApplicationsController < ApplicationController
  skip_before_filter :pending_applicant, only: :show
  skip_before_filter :new_applicant, only: :index
  def index 
    
  end

  def show
  end
end
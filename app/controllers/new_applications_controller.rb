class NewApplicationsController < ApplicationController
  skip_before_filter :pending_applicant, only: :show
  skip_before_filter :new_applicant, only: :index
  skip_before_filter :require_code_of_conduct

  def index

  end

  def show
  end
end

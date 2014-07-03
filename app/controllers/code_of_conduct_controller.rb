class CodeOfConductController < ApplicationController
  skip_before_filter :require_code_of_conduct

  def show
  end

  def accept
    current_user.accept_code_of_conduct
    redirect_to :root
  end
end

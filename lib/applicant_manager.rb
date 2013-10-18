module ApplicantManager

  def index
    @pending_applications = application_model.pending
    @applicants = associated_users(@pending_applications)
  end

  def new
    @application = application_model.new
  end

  def create
    @application = application_model.new(application_params)
    @application.user_uuid = current_user.uuid
    if @application.save
      flash[:notice] = 'Application Submitted'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @application = application_model.find(params[:id])
    if can? :read, @application
      render 'show'
    else
      redirect_to root_path, alert: "Not authorized"
    end
  end

  def update 
    @application = application_model.find(params[:id])
    if can? :update, @application
      @application.update(application_params)
      if @application.approved?
        flash[:notice] = "Application approved"
      else
        flash[:notice] = "Application rejected"
      end
      redirect_to review_applications_index_path
    else
      redirect_to root_path, alert: "Not authorized"
    end   
  end
end
module ApplicantManager

  def index
    @pending_applications = application_model.pending
  end

  def new
    @application = application_model.new(user_uuid: current_user.uuid)
  end

  def create
    @application = application_model.new(application_params)
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
      redirect_to @application
    else
      redirect_to root_path, alert: "Not authorized"
    end   
  end
end
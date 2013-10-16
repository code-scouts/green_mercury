class ConceptsController < ApplicationController
  def index
    @concepts = Concept.all
  end

  def new
    @concept = Concept.new
  end

  def create
    @concept = Concept.new(concept_params)
    if @concept.save
      flash[:notice] = "Your concept has been added."
      redirect_to @concept
    else
      render 'new'
    end
  end

  def show
    @concept = Concept.find(params[:id])
    uuids = @concept.history.map { |history| history.user_uuid }
    @users = User.fetch_from_uuids(uuids)
  end

private
  def concept_params
    params.require(:concept).permit(:name, concept_descriptions_attributes: [:description, :user_uuid])
  end
end


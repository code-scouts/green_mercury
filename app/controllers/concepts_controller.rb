#It shouldn't be possible to create two concepts with the same name.
#Create a unique index, validate_uniqueness_of :name,
#and add a RecordExistsError handler in the ConceptsController.
#should flash that record exists, including it's name and location
#and redirect to creating a new page, using information
#that allready was entered

class ConceptsController < ApplicationController
  def index
    @concepts = Concept.all
  end

  def new
    @concept = Concept.new
  end

  def create
    begin
      @concept = Concept.new(concept_params)
      if @concept.save
        flash[:notice] = "Your concept has been added."
        redirect_to @concept
      end
    rescue ActiveRecord::RecordNotUnique => e
      other_concept = Concept.find_by(name: @concept.name)
      flash[:notice] = "#{@concept.name} already exists: #{concept_url(other_concept)}"
      render 'new'
    end
  end

  def show
    @concept = Concept.includes(:concept_descriptions).find(params[:id])
    uuids = @concept.concept_descriptions.pluck(:user_uuid)
    @users = User.fetch_from_uuids(uuids)
  end

private
  def concept_params
    params.require(:concept).permit(:name, concept_descriptions_attributes: [:description, :user_uuid])
  end
end


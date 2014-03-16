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
      flash[:notice] = "#{@concept.name} already exists: #{link_to(concept_url(other_concept))}"
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


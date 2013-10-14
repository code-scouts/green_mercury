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
      flash[:notice] = "Your concept as been added."
      redirect_to '/'
    else
      render 'new'
    end
  end

  def show
    @concept = Concept.find(params[:id])
  end

private
  def concept_params
    params.require(:concept).permit(:name, concept_contents_attributes: [:content])
  end
end
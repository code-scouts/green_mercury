class ConceptDescriptionsController < ApplicationController

  def new
    @user = current_user
    @concept_description = ConceptDescription.new
    @concept_id = params[:concept_id]
    @old_description = Concept.find(params[:concept_id]).latest.description
  end

  def create
    @concept = Concept.find(params[:concept_description][:concept_id])
    @concept_description = @concept.concept_descriptions.new(concept_description_params)
    if @concept_description.save
      respond_to do |format|
        format.html { redirect_to concept_path(@concept) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'new' }
      end
    end
  end

  def destroy
    @description = ConceptDescription.find(params[:id])
    @description.destroy
    flash[:notice] = "Description reverted."
    redirect_to concept_path(@description.concept)
  end

private

  def concept_description_params
    params.require(:concept_description).permit(:description, :user_uuid)
  end
end
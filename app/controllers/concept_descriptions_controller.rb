class ConceptDescriptionsController < ApplicationController
  def destroy
    @description = ConceptDescription.find(params[:id])
    @description.destroy
    flash[:notice] = "Description reverted."
    redirect_to concept_path(@description.concept)
  end
end
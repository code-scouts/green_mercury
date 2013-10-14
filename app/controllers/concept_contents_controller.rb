class ConceptContentsController < ApplicationController
  def destroy
    @content = ConceptContent.find(params[:id])
    @content.destroy
    flash[:notice] = "Description reverted."
    redirect_to concept_path(@content.concept)
  end
end
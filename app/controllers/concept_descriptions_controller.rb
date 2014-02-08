class ConceptDescriptionsController < ApplicationController

  def new
    @concept_description = ConceptDescription.new
    @concept_id = params[:concept_id]
    @old_description = Concept.find(params[:concept_id]).latest.description
  end

  def create
    @concept = Concept.find(params[:concept_description][:concept_id])
    uuids = @concept.concept_descriptions.map { |history| history.user_uuid }
    @users = User.fetch_from_uuids(uuids)
    @concept_description = @concept.concept_descriptions.new(concept_description_params)
    if @concept_description.save
      respond_to do |format|
        format.html { redirect_to concept_path(@concept) }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to 'new' }
      end
    end
  end

  def destroy
    @description = ConceptDescription.find(params[:id])
    unless @description.concept.concept_descriptions.length == 1
      @description.destroy
      flash[:notice] = "Description updated."
      redirect_to concept_path(@description.concept)
    end
  end

private

  def concept_description_params
    params.require(:concept_description).permit(:description, :user_uuid)
  end
end
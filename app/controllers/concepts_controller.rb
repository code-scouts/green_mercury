class ConceptsController < ApplicationController
  def new
    @concept = Concept.new
  end
end
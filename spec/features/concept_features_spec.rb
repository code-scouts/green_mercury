require 'spec_helper'

feature 'create concepts' do
  # before :each do
  #   User.stub(:from_uuids, { '1' => 'Captain Awesome' })
  #   @user = User.new
  #   ConceptsController.stub current_user: @user
  # end
  
  scenario 'user fills out all fields correctly' do
    visit new_concept_path
    fill_in 'Name', with: 'New Concept'
    fill_in 'Description', with: 'This does stuff'
    click_button('Add Concept')
    page.should have_content 'Your concept has been added.'
  end

  scenario 'user does not fill in description' do
    visit new_concept_path
    fill_in 'Name', with: 'New Concept'
    click_button('Add Concept')
    page.should have_content 'error'
  end
end

feature 'view concepts by name' do 
  scenario 'user clicks link to view all concepts' do
    concept = FactoryGirl.create(:concept_description)
    visit concepts_path
    page.should have_content concept.concept.name
  end
end

feature 'revert to older description' do
  before do
    @concept = FactoryGirl.create(:concept)
    ConceptDescription.create(description: 'better description', concept_id: @concept.id)
  end

  scenario 'user reverts to previous description' do
    description2 = ConceptDescription.create(description: 'get rid of this', concept_id: @concept.id)
    visit concept_path(@concept)
    click_link 'Delete and revert to previous description'
    page.should_not have_content description2.description
  end

  scenario 'user cannot revert if there are no previous descriptions' do
    visit concept_path(@concept)
    page.should_not have_content 'Revert'
  end
end

feature 'add a new description to existing concept' do
  before do
    @concept = FactoryGirl.create(:concept)
    ConceptDescription.create(description: 'better description', concept_id: @concept.id)
    visit concept_path(@concept)
    click_link 'Edit description'
  end

  scenario 'user adds a valid description' do
    fill_in 'concept_description_description', with: 'latest description'
    click_button('Submit New Description')
    page.should have_content 'latest description'
  end

  scenario 'user adds an invalid description' do
    click_button('Submit New Description')
    page.should_not have_link 'Revert'
  end
end

feature 'delete a description' do
  scenario 'user deletes a description' do
    concept = FactoryGirl.create(:concept)
    description1 = ConceptDescription.create(description: 'better description', concept_id: concept.id)
    description2 = ConceptDescription.create(description: 'best description', concept_id: concept.id)
    visit concept_path(concept)
    click_link 'Delete'
    page.should_not have_content description1.description
  end
end


require 'spec_helper'

feature 'create concepts' do
  before :each do
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    visit new_concept_path
  end
  
  scenario 'user fills out all fields correctly' do
    fill_in 'concept_name', with: 'New Concept'
    fill_in 'Description', with: 'This does stuff'
    click_button('Add Concept')
    page.should have_content 'Your concept has been added.'
  end

  scenario 'user does not fill in description' do
    fill_in 'concept_name', with: 'New Concept'
    click_button('Add Concept')
    page.should have_content 'error'
  end

  scenario 'user does not fill in name' do
    fill_in 'Description', with: 'This does stuff'
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
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    @concept_description = FactoryGirl.create(:concept_description, user_uuid: @user.uuid)
    @concept = @concept_description.concept
  end

  scenario 'user reverts to previous description' do
    description2 = @concept.concept_descriptions.create(description: 'get rid of this', user_uuid: @user.uuid)
    visit concept_path(@concept)
    click_link 'Revert to previous description'
    page.should_not have_content description2.description
  end

  scenario 'user cannot revert if there are no previous descriptions' do
    visit concept_path(@concept)
    page.should_not have_content 'Revert'
  end
end

feature 'add a new description to existing concept' do
  before do
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    @concept_description = FactoryGirl.create(:concept_description, user_uuid: @user.uuid)
    @concept = @concept_description.concept
    visit concept_path(@concept)
    click_link 'Edit description'
  end

  scenario 'user adds a valid description', js: true do
    fill_in 'concept_description_description', with: 'latest description'
    click_button('Save')
    page.should have_content 'latest description'
  end

  scenario 'user adds an invalid description', js: true do
    fill_in 'concept_description_description', with: ''
    click_button('Save')
    page.should_not have_link 'Revert to previous description'
  end

  scenario 'a user adds a valid description with markdown', js: true do 
    fill_in 'concept_description_description', with: "Look what I can do:\n\n ```ruby \n puts 'Hello World!' \n ```"
    click_button 'Save'  
    within('#latest-description') { expect(page).to have_css('.highlight') }
  end

  scenario 'user clicks cancel button', js: true do
    click_button('Cancel')
    page.should have_content 'Edit description'
  end
end

feature 'delete a description' do
  scenario 'user deletes a description' do
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    concept = FactoryGirl.create(:concept)
    description1 = concept.concept_descriptions.create(description: 'better description', user_uuid: @user.uuid)
    description2 = concept.concept_descriptions.create(description: 'best description', user_uuid: @user.uuid)
    visit concept_path(concept)
    click_link 'Delete'
    page.should_not have_content description1.description
  end
end

feature 'view all concepts' do  
  scenario 'click on concept name' do
    Concept.all.each { |concept| concept.destroy }
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    concept_description = FactoryGirl.create(:concept_description, user_uuid: @user.uuid)
    concept = concept_description.concept
    visit concepts_path
    click_link concept.name
    page.should have_content concept_description.description
  end
end


require 'spec_helper'

feature 'create concepts' do 
  scenario 'user fills out all fields correctly' do
    visit new_concept_path
    fill_in 'Name', with: 'New Concept'
    fill_in 'Description', with: 'This does stuff'
    click_button("Add Concept")
    page.should have_content "Your concept has been added."
  end

  scenario 'user does not fill in description' do
    visit new_concept_path
    fill_in 'Name', with: 'New Concept'
    click_button("Add Concept")
    page.should have_content "description can't be blank"
  end
end

feature 'view concepts by name' do 
  scenario 'user clicks link to view all concepts' do
    concept = FactoryGirl.create(:concept_description)
    visit concepts_path
    page.should have_content concept.concept.name
  end
end

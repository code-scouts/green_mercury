require 'spec_helper'

feature 'apply to be a mentor' do
  before do
    user = User.new
    ApplicationController.any_instance.stub(:current_user) { user }
    MentorApplicationsController.any_instance.stub(:current_user) { user }
  end

  scenario 'submit a valid mentor application' do
    visit root_path
    click_link 'Apply to be a mentor'
    fill_in 'mentor_application_content', with: 'stuff about me'
    click_button 'Submit Application'
    expect(page).to have_content 'Application Submitted'
  end

  scenario 'invalid mentor application' do 
    visit root_path
    click_link 'Apply to be a mentor'
    click_button 'Submit Application'
    page.should have_content "error"
  end
end


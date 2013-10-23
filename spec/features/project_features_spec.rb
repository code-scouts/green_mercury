require 'spec_helper'

feature 'create a project' do
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'a mentor creates a valid project' do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    fill_in 'project_description', with: 'We are going to do things'
    click_on 'Create'
    page.should have_content "successfully"
  end

  scenario 'a mentor tries to create an invalid project' do 
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    click_on 'Create'
    page.should have_content 'error'
  end

  scenario "a non-mentor user tries to create a project" do 
    user = new_member
    ApplicationController.any_instance.stub(:current_user) { user }
    visit root_path
    click_link 'Projects'
    page.should_not have_content 'Create a Project'

    visit new_project_path
    page.should have_content 'Not authorized'

    page.driver.submit :post, projects_path(project: {:title => 'Hello', :description => 'Goodbye', :start_date => Time.now, :end_date => Time.now + 1.month }), {}
    page.should have_content 'Not authorized'
  end
end

feature 'create project team', js: true do
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'a project organizer adds mentors when creating a project' do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    fill_in_ckeditor 'project_description', with: 'We are going to do things'
    click_link 'Add new mentor'
    fill_in 'Role', with: 'Front-end'
    click_on 'Create'
    within('#mentors') { page.should have_content 'Front-end' }
  end

  scenario 'a project organizer adds members when creating a project' do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    fill_in_ckeditor 'project_description', with: 'We are going to do things'
    click_link 'Add new member'
    fill_in 'Role', with: 'Front-end'
    click_on 'Create'
    within('#members') { page.should have_content 'Front-end' }
  end

end

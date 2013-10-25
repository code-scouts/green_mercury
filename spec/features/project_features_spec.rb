require 'spec_helper'

feature 'create a project' do
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'a mentor creates a valid project', js: true do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    page.execute_script("$('#project_description').data('wysihtml5').editor.setValue('We are going');")
    click_on 'Submit'
    page.should have_content "successfully"
  end

  scenario 'a mentor tries to create an invalid project' do 
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    click_on 'Submit'
    page.should have_content 'error'
  end

  context "a non-mentor user tries to create a project" do
    before do
      user = new_member
      ApplicationController.any_instance.stub(:current_user) { user }
    end

    scenario "they can't see the link" do
      visit root_path
      click_link 'Projects'
      page.should_not have_content 'Create a Project'
    end

    scenario "they can't visit the path directly" do
      visit new_project_path
      page.should have_content 'Not authorized'
    end

    scenario "they can't make a POST request directly" do
      page.driver.submit :post, projects_path(project: {:title => 'Hello', :description => 'Goodbye', :start_date => Time.now, :end_date => Time.now + 1.month }), {}
      page.should have_content 'Not authorized'
    end
  end
end

feature 'create project team', js: true do
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'a project organizer adds mentors when creating a project', js: true do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    page.execute_script("$('#project_description').data('wysihtml5').editor.setValue('We are going');")
    click_link 'Add new mentor'
    fill_in 'Role', with: 'Front-end'
    click_on 'Submit'
    within('#mentors') { page.should have_content 'Front-end' }
  end

  scenario 'a project organizer adds members when creating a project', js: true do
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    page.execute_script("$('#project_description').data('wysihtml5').editor.setValue('We are going');")
    click_link 'Add new member'
    fill_in 'Role', with: 'Front-end'
    click_on 'Submit'
    within('#members') { page.should have_content 'Front-end' }
  end

  scenario 'a project organizer adds an invalid mentor when creating a project', js: true do 
    visit root_path
    click_link 'Projects'
    click_link 'Create a Project'
    fill_in 'project_title', with: 'Things to do'
    fill_in 'project_start_date', with: Date.today
    fill_in 'project_end_date', with: Date.today + 1.month
    page.execute_script("$('#project_description').data('wysihtml5').editor.setValue('We are going');")
    click_link 'Add new mentor'
    click_on 'Submit'
    page.should have_content 'error' 
  end
end

feature 'join a project as a mentor' do 
  before :each do 
    @project = FactoryGirl.create(:project)
    @mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: nil, project: @project)
  end

  scenario 'a mentor successfully joins a project' do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    visit root_path
    click_link 'Projects'
    click_link @project.title 
    click_link @mentor_participation.role
    page.should have_content 'successfully'
    within('#mentors') { page.should have_content user.name }
  end

  scenario 'a member tries to join a project as a mentor' do
    user = new_member
    ApplicationController.any_instance.stub(:current_user) { user }
    visit project_path @project
    click_link @mentor_participation.role
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor tries to join a project they have already joined' do
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    FactoryGirl.create(:mentor_participation, project: @project, user_uuid: user.uuid)
    visit project_path @project
    click_link @mentor_participation.role
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor tries to join a project that has no open mentor slots' do
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    @mentor_participation.update(user_uuid: 'taken-uuid')
    page.driver.submit :patch, mentor_participation_path(@mentor_participation), {}
    page.should have_content 'Not authorized'
  end
end

feature 'join a project as a member' do 
  before :each do 
    @project = FactoryGirl.create(:project)
    @member_participation = FactoryGirl.create(:member_participation, user_uuid: nil, project: @project)
  end

  scenario 'a member successfully joins a project' do 
    user = new_member
    ApplicationController.any_instance.stub(:current_user) { user }
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    visit root_path
    click_link 'Projects'
    click_link @project.title 
    click_link @member_participation.role
    page.should have_content 'successfully'
    within('#members') { page.should have_content user.name }
  end

  scenario 'a mentor tries to join a project as a member' do
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    visit project_path @project
    click_link @member_participation.role
    page.should have_content 'Not authorized'
  end

  scenario 'a member tries to join a project they have already joined' do
    user = new_member
    ApplicationController.any_instance.stub(:current_user) { user }
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    FactoryGirl.create(:member_participation, project: @project, user_uuid: user.uuid)
    visit project_path @project
    click_link @member_participation.role
    page.should have_content 'Not authorized'
  end

  scenario 'a member tries to join a project that has no open member slots' do
    user = new_member
    ApplicationController.any_instance.stub(:current_user) { user }
    @member_participation.update(user_uuid: 'taken-uuid')
    page.driver.submit :patch, member_participation_path(@member_participation), {}
    page.should have_content 'Not authorized'
  end
end

feature 'edit a project' do 
  context 'the project owner edits the project' do 
    before do 
      user = new_mentor
      ApplicationController.any_instance.stub(:current_user) { user }
      @project = FactoryGirl.create(:project, user_uuid: user.uuid)
      User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
      visit project_path @project
      click_link 'Edit Project'
    end

    scenario 'they edit the project details' do 
      fill_in 'project_title', with: "New Project Name"
      click_on 'Submit'
      within('#project-info') { page.should have_content "New Project Name" }
    end

    scenario 'they edit the mentor participations', js: true do 
      click_link 'Add new mentor'
      fill_in 'Role', with: 'Front-end'
      click_on 'Submit'
      within('#mentors') { page.should have_content 'Front-end' }
    end

    scenario 'they edit the member participations', js: true do 
      click_link 'Add new member'
      fill_in 'Role', with: 'Front-end'
      click_on 'Submit'
      within('#members') { page.should have_content 'Front-end' }
    end
  end

  context 'a non-project owner tries to edit a project' do 
    before do 
      project_owner = new_mentor
      @project = FactoryGirl.create(:project, user_uuid: project_owner.uuid)
      User.stub(:fetch_from_uuids).and_return({ project_owner.uuid => project_owner })
      user = new_member
      ApplicationController.any_instance.stub(:current_user) { user }
    end

    scenario "they can't see the link" do 
      visit project_path @project
      page.should_not have_content 'Edit Project'
    end

    scenario "they can't visit the path directly" do 
      visit edit_project_path @project 
      page.should have_content 'Not authorized'
    end

    scenario "they can't submit a PATCH request directly" do 
      page.driver.submit :patch, project_path(id: @project.id, project: {:title => 'Hello', :description => 'Goodbye', :start_date => Time.now, :end_date => Time.now + 1.month }), {}
      page.should have_content 'Not authorized'
    end
  end
end











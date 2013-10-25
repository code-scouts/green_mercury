require 'spec_helper'

feature 'posting on a project' do 
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    @project = FactoryGirl.create(:project)
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: user.uuid, project: @project)
  end

  scenario 'a project team member creates a valid post on a project' do 
    visit project_path(@project)
    click_link 'New Post'
    fill_in 'post_title', with: 'Does this thing work?'
    fill_in 'post_content', with: 'Hey does this thing work?'
    within('form') { click_on 'Submit' }
    within('#discussion') { page.should have_content 'Does this thing work?'}
  end

  scenario 'a project team member creates an invalid post on a project' do 
    visit project_path(@project)
    click_link 'New Post'
    within('form') { click_on 'Submit' }
    page.should have_content 'error'
  end

  scenario 'a user that is not a project participant tries to post on a project' do 
    member = new_member
    ApplicationController.any_instance.stub(:current_user) { member }
    visit project_path(@project)
    page.should_not have_content 'New Post'

    visit new_post_path(project_id: @project.id)
    page.should have_content 'Not authorized'

    page.driver.submit :post, posts_path(:post => { :title => 'Hello?', :content => "Anyone home?", :project_id => @project.id }), {}
    page.should have_content 'Not authorized'
  end
end
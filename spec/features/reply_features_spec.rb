require 'spec_helper'

feature 'replying to a post' do 
  before :each do 
    user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { user }
    @project = FactoryGirl.create(:project)
    @post = FactoryGirl.create(:post, project: @project, user_uuid: user.uuid)
    User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
    mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: user.uuid, project: @project)
  end

  scenario 'a project team member creates a valid reply to a post', js: true do 
    visit project_path(@project)
    click_link 'Reply'
    fill_in 'reply_content', with: 'Hey does this thing work?'
    within('form') { click_on 'Submit' }
    within('#discussion') { page.should have_content 'Hey does this thing work?'}
  end

  scenario 'a project team member creates an invalid reply to a post' do
    visit project_path(@project)
    click_link 'Reply'
    within('form') { click_on 'Submit' }
    page.should have_content 'error'
  end

  scenario 'a user that is not a project participant tries to reply to a post' do 
    member = new_member
    ApplicationController.any_instance.stub(:current_user) { member }
    visit project_path(@project)
    page.should_not have_content 'Reply'

    visit new_reply_path(post_id: @post.id)
    page.should have_content 'Not authorized'

    page.driver.submit :post, replies_path(:reply => { :content => "Anyone home?", :post_id => @post.id }), {}
    page.should have_content 'Not authorized'
  end
end
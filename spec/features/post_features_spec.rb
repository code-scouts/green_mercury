# require 'spec_helper'

# feature 'posting on a project' do 
#   before :each do 
#     user = new_mentor
#     ApplicationController.any_instance.stub(:current_user) { user }
#     @project = FactoryGirl.create(:project)
#     User.stub(:fetch_from_uuids).and_return({ user.uuid => user })
#     mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: user.uuid, project: @project)
#   end

#   context 'a project team member' do 
#     scenario 'they create a valid post on a project', js: true do 
#       visit project_path(@project)
#       click_link 'New Post'
#       fill_in 'post_title', with: 'Does this thing work?'
#       fill_in 'post_content', with: 'Hey does this thing work?'
#       within('form') { click_on 'Submit' }
#       within('#discussion') { page.should have_content 'Does this thing work?'}
#     end

#     scenario 'they create an invalid post on a project', js: true do 
#       visit project_path(@project)
#       click_link 'New Post'
#       within('form') { click_on 'Submit' }
#       page.should have_content 'error'
#     end
#   end

#   context 'a user that is not a project participant tries to create a post' do
#     before do 
#       member = new_member
#       ApplicationController.any_instance.stub(:current_user) { member }
#     end

#     scenario "they can't see the link" do 
#       visit project_path(@project)
#       page.should_not have_content 'New Post'
#     end

#     scenario "they can't visit the path directly" do 
#       visit new_post_path(project_id: @project.id)
#       page.should have_content 'Not authorized'
#     end

#     scenario "they can't send a POST request directly" do 
#       page.driver.submit :post, posts_path(:post => { :title => 'Hello?', :content => "Anyone home?", :project_id => @project.id }), {}
#       page.should have_content 'Not authorized'
#     end
#   end
# end

















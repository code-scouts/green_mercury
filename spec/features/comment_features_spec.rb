require 'spec_helper'

feature 'comment on a project' do 
  before do 
    @user = new_mentor
    ApplicationController.any_instance.stub(:current_user) { @user }
    @project = FactoryGirl.create(:project)
    User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
  end

  context 'as a project team member' do
    before do 
      mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: @user.uuid, project: @project)
    end

    scenario 'they successfully submit a comment' do 
      visit project_path(@project)
      click_link 'New Post'
      fill_in 'comment_title', with: "Does this thing work?"
      fill_in 'comment_comment', with: "Testing 1, 2, 3"
      within('form') { click_on 'Submit' }
      within('#discussion') { page.should have_content 'Does this thing work?' }
    end

    scenario 'they submit an invalid comment' do 
      visit project_path(@project)
      click_link 'New Post'
      within('form') { click_on 'Submit' }
      within('form') { page.should have_content "can't" }
    end
  end

  context 'as a non-team member' do 
    scenario "they can't see the new post button" do 
      visit project_path(@project)
      page.should_not have_content 'New Post'
    end

    scenario "they can't visit the page directly" do 
      visit new_comment_path(commentable_id: @project.id, commentable_type: 'Project')
      page.should have_content 'Not authorized'
    end

    scenario "they can't submit a POST request directly" do 
      page.driver.submit :post, comments_path(:comment => {title: "Does this work?", comment: "I hope not", commentable_id: @project.id, commentable_type: 'Project'}), {}
      page.should have_content 'Not authorized'
    end
  end
end

feature 'reply to a comment' do 
  context 'on a project' do 
    before do 
      @user = new_mentor
      ApplicationController.any_instance.stub(:current_user) { @user }
      @project = FactoryGirl.create(:project_with_comment)
      User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user, '1' => new_member })
    end

    context 'as a project team member' do 
      before do 
        mentor_participation = FactoryGirl.create(:mentor_participation, user_uuid: @user.uuid, project: @project)
      end

      scenario 'they successfully reply' do 
        visit project_path(@project)
        click_link 'Reply'
        fill_in 'comment_title', with: "Does this thing work?"
        fill_in 'comment_comment', with: "Testing 1, 2, 3"
        within('form') { click_on 'Submit' }
        within('#discussion') { page.should have_content 'Testing 1, 2, 3' }
      end
    end

    context 'when not on the project team' do
      let(:comment) { @project.comments.first } 
      
      scenario 'they should not see the button' do 
        visit project_path(@project)
        page.should_not have_content 'Reply'
      end

      scenario 'they should not be able to visit the path directly' do 
        visit new_comment_path(commentable_id: comment.id, commentable_type: 'Comment')
        page.should have_content 'Not authorized'
      end

      scenario 'they should not be able to submit a POST request directly' do 
        page.driver.submit :post, comments_path(:comment => {title: "My title", comment: 'my comment', commentable_type: 'Comment', commentable_id: comment.id}), {}
        page.should have_content 'Not authorized'
      end
    end
  end
end

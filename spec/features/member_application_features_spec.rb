require 'spec_helper'

feature 'apply to be a member' do
  before do
    user = User.new
    ApplicationController.any_instance.stub(:current_user) { user }
    MemberApplicationsController.any_instance.stub(:current_user) { user }
  end

  scenario 'submit a valid member application' do
    visit root_path
    click_link 'Apply to be a member'
    fill_in 'member_application_content', with: 'stuff about me'
    click_button 'Submit Application'
    expect(page).to have_content 'Application Submitted'
  end

  scenario 'invalid member application' do 
    visit root_path
    click_link 'Apply to be a member'
    click_button 'Submit Application'
    page.should have_content 'error'
  end
end

feature 'see the status of the application' do
  scenario 'a user has a pending member application' do
    user = FactoryGirl.build(:user)
    FactoryGirl.create(:member_application, approved_date: nil, user_uuid: user.uuid)
    ApplicationController.any_instance.stub(:current_user) { user }

    visit root_path
    page.should have_content 'Status: Pending'
  end
end
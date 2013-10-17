require 'spec_helper'

feature 'apply to be a member' do
  before do
    user = User.new
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'submit a valid member application' do
    visit root_path
    click_link 'Apply to be a member'
    fill_in 'member_application_name', with: "Bob"
    choose 'member_application_why_you_want_to_join_hobby'
    fill_in 'member_application_gender', with: 'female'
    fill_in 'member_application_experience_level', with: 'Experience'
    choose 'member_application_confidence_technical_skills_1'
    choose 'member_application_basic_programming_knowledge_1'
    choose 'member_application_comfortable_learning_1'
    fill_in 'member_application_current_projects', with: 'Projects'
    choose 'member_application_time_commitment_fewer_than_2'
    fill_in 'member_application_hurdles', with: 'Hurdles'
    fill_in 'member_application_excited_about', with: 'Excited'
    fill_in 'member_application_anything_else', with: 'Something Else'
    click_on 'Submit'
    expect(page).to have_content 'Application Submitted'
  end

  scenario 'invalid member application' do 
    visit root_path
    click_link 'Apply to be a member'
    click_on 'Submit'
    page.should have_content 'error'
  end
end

feature 'see the status of the application' do
  scenario 'a user has a pending member application' do
    user = FactoryGirl.build(:user)
    FactoryGirl.create(:member_application, approved_date: nil, user_uuid: user.uuid)
    ApplicationController.any_instance.stub(:current_user) { user }
    visit root_path
    page.should have_content 'Thank you for applying'
  end
end

feature 'accept or reject a new member application' do 
  scenario 'an admin accepts an application' do 
    admin = FactoryGirl.build(:admin)
    user = FactoryGirl.build(:user)
    application = FactoryGirl.create(:member_application, user_uuid: user.uuid)
    ApplicationController.any_instance.stub(:current_user) { admin }
    visit member_applications_path
    click_link application.name 
    click_link 'Approve'
    page.should have_content 'Application approved' 
  end

  scenario 'an admin rejects an application' do 
    admin = FactoryGirl.build(:admin)
    application = FactoryGirl.create(:member_application)
    ApplicationController.any_instance.stub(:current_user) { admin }
    visit member_applications_path
    click_link application.name 
    click_link 'Reject'
    page.should have_content 'Application rejected'
  end

  scenario 'a non-admin attempts to approve an application' do 
    user = new_mentor
    application = FactoryGirl.create(:member_application)
    ApplicationController.any_instance.stub(:current_user) { user }
    visit member_application_path(application)
    page.should have_content 'Not authorized'
  end
end




















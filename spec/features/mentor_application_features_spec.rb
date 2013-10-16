require 'spec_helper'

feature 'apply to be a mentor' do
  before do
    user = FactoryGirl.build(:user)
    ApplicationController.any_instance.stub(:current_user) { user }
  end

  scenario 'submit a valid mentor application' do
    visit root_path
    click_link 'Apply to be a mentor'
    fill_in 'mentor_application_name', with: 'Name'
    fill_in 'mentor_application_contact', with: 'Email'
    choose 'mentor_application_geography_online'
    select("Women's XL", :from => 'mentor_application_shirt_size')
    choose 'mentor_application_hear_about_google'
    fill_in 'mentor_application_motivation', with: 'Stuff'
    choose 'mentor_application_time_commitment_bit'
    choose 'mentor_application_mentor_one_on_one_very_interested'
    choose 'mentor_application_mentor_group_very_interested'
    choose 'mentor_application_mentor_online_very_interested'
    choose 'mentor_application_volunteer_events_very_interested'
    choose 'mentor_application_volunteer_teams_very_interested'
    choose 'mentor_application_volunteer_solo_very_interested'
    choose 'mentor_application_volunteer_technical_very_interested'
    choose 'mentor_application_volunteer_online_very_interested'
    click_button 'Submit'
    expect(page).to have_content 'Application Submitted'
  end

  scenario 'invalid mentor application' do 
    visit root_path
    click_link 'Apply to be a mentor'
    click_button 'Submit'
    page.should have_content "error"
  end
end

feature 'see the status of an application' do 
  scenario 'a user has a pending mentor application' do 
    user = FactoryGirl.build(:user)
    FactoryGirl.create(:mentor_application, approved_date: nil, user_uuid: user.uuid)
    ApplicationController.any_instance.stub(:current_user) { user }
    visit root_path 
    page.should have_content "Thank you for applying"
  end
end


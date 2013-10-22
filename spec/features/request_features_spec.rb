require 'spec_helper'

feature 'create a request' do
  before do
    user = new_member
    RequestsController.any_instance.stub(:current_user).and_return(user)
    visit new_request_path
    fill_in 'request_title', with: 'need help with rails'
    fill_in 'request_content', with: 'understanding the basics'
  end

  scenario 'a member creates a valid request' do
    fill_in 'request_contact_info', with: 'my cell phone for sure'
    click_button 'Submit'
    page.should have_content 'successfully'
  end

  scenario 'a user attempts to create an invalid request' do 
    click_button 'Submit'
    page.should have_content 'error'
  end
end
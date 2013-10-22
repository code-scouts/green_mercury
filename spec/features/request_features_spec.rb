require 'spec_helper'

feature 'create a request' do
  before do
    @user1 = new_member
    stub_requests_controllers
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

feature 'edit a request' do
  before do
    @user1 = new_member
    stub_requests_controllers
    @request = FactoryGirl.create(:request, member_uuid: @user1.uuid)
    visit edit_request_path @request
  end

  scenario 'a member creates a valid request' do
    fill_in 'Title', with: 'new request title'
    click_button 'Submit'
    page.should have_content 'new request title'
  end

  scenario 'a user attempts to create an invalid request' do
    fill_in 'Title', with: ''
    click_button 'Submit'
    page.should have_content 'error'
  end
end
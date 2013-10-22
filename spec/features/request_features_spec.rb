require 'spec_helper'

feature 'create a request' do
  before :each do
    @user1 = new_member
    stub_requests_controllers
    visit new_request_path
  end

  scenario 'a member creates a valid request' do
    fill_in 'request_title', with: 'need help with rails'
    fill_in 'request_content', with: 'understanding the basics'
    fill_in 'request_contact_info', with: 'my cell phone for sure'
    click_button 'Submit'
    page.should have_content 'successfully'
  end

  scenario 'a member attempts to create an invalid request' do 
    click_button 'Submit'
    page.should have_content 'errors'
  end

  scenario 'a mentor attempts to create a request' do
    @user1 = new_mentor
    stub_requests_controllers
    visit new_request_path
    page.should have_content 'not authorized'
    page.driver.submit :post, requests_path(request: {title: 'my title', content: 'some content', contact_info: 'get in touch', member_uuid: @user1.uuid}), {}
  end
end

feature 'edit a request' do
  before :each do
    @user1 = new_member
    stub_requests_controllers
    @request = FactoryGirl.create(:request, member_uuid: @user1.uuid)
  end

  scenario 'a member creates a valid request' do
    visit edit_request_path @request
    fill_in 'Title', with: 'new request title'
    click_button 'Submit'
    page.should have_content 'new request title'
  end

  scenario 'a member attempts to create an invalid request' do
    visit edit_request_path @request
    fill_in 'Title', with: ''
    click_button 'Submit'
    page.should have_content 'error'
  end

  scenario 'a member who did not create the request attempts to edit the request' do
    @user1 = new_member
    stub_requests_controllers
    visit edit_request_path @request
    page.should have_content 'not authorized'
    page.driver.submit :patch, request_path(@request), {}
  end

  scenario 'a mentor attempts to edit a request' do
    @user1 = new_mentor
    stub_requests_controllers
    visit edit_request_path @request
    page.should have_content 'not authorized'
    page.driver.submit :patch, request_path(@request), {}
  end
end
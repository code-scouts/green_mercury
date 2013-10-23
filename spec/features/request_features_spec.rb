require 'spec_helper'

feature 'create a request' do
  before :each do
    @user1 = new_member
    stub_user_fetch_from_uuid
    stub_requests_controllers
    visit requests_path
  end

  scenario 'a member creates a valid request' do
    click_link 'Create a request'
    fill_in 'request_title', with: 'need help with rails'
    fill_in 'request_content', with: 'understanding the basics'
    fill_in 'request_contact_info', with: 'my cell phone for sure'
    click_button 'Submit'
    page.should have_content 'successfully'
  end

  scenario 'a member attempts to create an invalid request' do
    click_link 'Create a request'
    click_button 'Submit'
    page.should have_content 'errors'
  end

  scenario 'a mentor attempts to create a request' do
    @user1 = new_mentor
    stub_requests_controllers
    visit requests_path
    page.should_not have_content 'Create a request'
    visit new_request_path
    page.should have_content 'Not authorized'
    visit requests_path
    page.driver.submit :post, requests_path(request: {title: 'my title', content: 'some content', contact_info: 'get in touch', member_uuid: @user1.uuid}), {}
    page.should have_content 'Not authorized'
  end
end

feature 'edit a request' do
  before :each do
    @user1 = new_member
    stub_user_fetch_from_uuid
    stub_requests_controllers
    @request = FactoryGirl.create(:request, member_uuid: @user1.uuid)
    visit request_path @request
  end

  scenario 'a member edits a request with valid information' do
    click_link 'Edit'
    fill_in 'Title', with: 'new request title'
    click_button 'Submit'
    page.should have_content 'new request title'
  end

  scenario 'a member attempts to edit a request with invalid information' do
    click_link 'Edit'
    fill_in 'Title', with: ''
    click_button 'Submit'
    page.should have_content 'error'
  end

  scenario 'a member who did not create the request attempts to edit the request' do
    @user1 = new_member
    stub_requests_controllers
    visit request_path @request
    within('.container') {page.should_not have_link 'Edit'}
    visit edit_request_path @request
    page.should have_content 'Not authorized'
    visit requests_path
    page.driver.submit :patch, request_path(@request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to edit a request' do
    @user1 = new_mentor
    stub_requests_controllers
    visit request_path @request
    within('.container') {page.should_not have_link 'Edit'}
    visit edit_request_path @request
    page.should have_content 'Not authorized'
    visit requests_path
    page.driver.submit :patch, request_path(@request), {}
    page.should have_content 'Not authorized'
  end
end

feature 'delete a request' do
  before :each do
    @user1 = new_member
    stub_user_fetch_from_uuid
    stub_requests_controllers
    @request = FactoryGirl.create(:request, member_uuid: @user1.uuid)
    visit request_path @request
  end

  scenario 'a member deletes a request' do
    click_link 'Delete'
    page.should_not have_content @request.title
  end

  scenario 'a member who did not create the request attempts to delete the request' do
    @user1 = new_member
    stub_requests_controllers
    visit request_path @request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, request_path(@request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to delete a request' do
    @user1 = new_mentor
    stub_requests_controllers
    visit request_path @request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, request_path(@request), {}
    page.should have_content 'Not authorized'
  end
end

feature 'view request page' do
  before :each do
    @request1 = FactoryGirl.create(:request)
    @request2 = FactoryGirl.create(:request, mentor_uuid: 'mentor-uuid')
  end

  scenario 'a member views an open request' do
    @user1 = new_member
    stub_requests_controllers
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    visit request_path(@request1)
    page.should have_content 'not yet been claimed'
  end

  scenario 'a member views a request that has been claimed' do
    @user1 = new_member
    stub_requests_controllers
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    visit request_path(@request2)
    page.should have_content 'has been claimed'
  end

  scenario 'a mentor views an open request' do
    @user1 = new_mentor
    stub_requests_controllers
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    visit request_path(@request1)
    page.should have_link 'Claim request'
  end

  scenario 'a mentor views a request they have claimed' do
    @user1 = new_mentor
    @request2.update(mentor_uuid: @user1.uuid)
    stub_requests_controllers
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    visit request_path(@request2)
    page.should have_content 'You claimed this request'
  end

  scenario 'a mentor views a request that has been claimed by someone else' do
    @user1 = new_mentor
    stub_requests_controllers
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    visit request_path(@request2)
    page.should have_content 'has already been claimed'
  end
end

feature 'requests index page' do
  before :each do
    @user1 = new_member
    stub_user_fetch_from_uuid
    stub_requests_controllers
    @request1 = FactoryGirl.create(:request)
    @request2 = FactoryGirl.create(:request)
    @request3 = FactoryGirl.create(:request, member_uuid: @user1.uuid)
    @request4 = FactoryGirl.create(:request, member_uuid: @user1.uuid)
  end

  scenario 'a member visits the page' do
    stub_user_fetch_from_uuid
    stub_requests_controllers
    visit requests_path
    page.should_not have_content @request1.title
    page.should_not have_content @request2.title
    page.should have_content @request3.title
    page.should have_content @request4.title
  end

  scenario 'a mentor visits the page' do
    @user1 = new_mentor
    @request1.update(mentor_uuid: @user1.uuid)
    @request3.update(mentor_uuid: 'other-mentor-uuid')
    stub_user_fetch_from_uuid
    stub_requests_controllers
    visit requests_path
    page.should have_content @request1.title
    page.should have_content @request2.title
    page.should_not have_content @request3.title
    page.should have_content @request4.title
  end
end
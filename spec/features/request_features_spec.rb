require 'spec_helper'

feature 'create a request' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
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
    @user = new_mentor
    stub_application_controller
    visit requests_path
    page.should_not have_content 'Create a request'
    visit new_request_path
    page.should have_content 'Not authorized'
    visit requests_path
    page.driver.submit :post, requests_path(request: {title: 'my title', content: 'some content', contact_info: 'get in touch', member_uuid: @user.uuid}), {}
    page.should have_content 'Not authorized'
  end
end

feature 'edit a request' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @request = FactoryGirl.create(:request, member_uuid: @user.uuid)
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
    @user = new_member
    stub_application_controller
    visit request_path @request
    within('.container') {page.should_not have_link 'Edit'}
    visit edit_request_path @request
    page.should have_content 'Not authorized'
    visit requests_path
    page.driver.submit :patch, request_path(@request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to edit a request' do
    @user = new_mentor
    stub_application_controller
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
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @request = FactoryGirl.create(:request, member_uuid: @user.uuid)
    visit request_path @request
  end

  scenario 'a member deletes a request' do
    click_link 'Delete'
    page.should_not have_content @request.title
  end

  scenario 'a member who did not create the request attempts to delete the request' do
    @user = new_member
    stub_application_controller
    visit request_path @request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, request_path(@request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to delete a request' do
    @user = new_mentor
    stub_application_controller
    visit request_path @request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, request_path(@request), {}
    page.should have_content 'Not authorized'
  end
end

feature 'a member views a request' do
  before :each do
    @user = new_member
    stub_application_controller
    stub_user_fetch_from_uuid
  end

  scenario 'their own request' do
    request = FactoryGirl.create(:request, member_uuid: @user.uuid)
    visit request_path(request)
    page.should have_content 'Contact Info:'
  end

  scenario 'another member\'s request' do
    request = FactoryGirl.create(:request)
    visit request_path(request)
    page.should_not have_content 'Contact Info:'
  end

  scenario 'open request' do
    request = FactoryGirl.create(:request)
    visit request_path(request)
    page.should have_content 'not been claimed'
  end

  scenario 'a request that has been claimed' do
    request = FactoryGirl.create(:request, mentor_uuid: 'mentor-uuid')
    visit request_path(request)
    page.should have_content 'has been claimed'
  end
end

feature 'a mentor views a request' do
  before :each do
    @request1 = FactoryGirl.create(:request)
    @request2 = FactoryGirl.create(:request, mentor_uuid: 'mentor-uuid')
    @user = new_mentor
    stub_application_controller
    stub_user_fetch_from_uuid
  end

  scenario 'open request' do
    request = FactoryGirl.create(:request)
    visit request_path(request)
    page.should have_button 'Claim request'
    page.should_not have_content 'Contact Info:'
  end

  scenario 'a request they have claimed' do
    request = FactoryGirl.create(:request, mentor_uuid: @user.uuid)
    visit request_path(request)
    page.should have_content 'You claimed this request'
    page.should have_content 'Contact Info:'
  end

  scenario 'a request that has been claimed by someone else' do
    request = FactoryGirl.create(:request, mentor_uuid: 'mentor-uuid')
    visit request_path(request)
    page.should have_content 'has already been claimed'
    page.should_not have_content 'Contact Info:'
  end
end

feature 'requests index page' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @request1 = FactoryGirl.create(:request)
    @request2 = FactoryGirl.create(:request)
    @request3 = FactoryGirl.create(:request, member_uuid: @user.uuid)
    @request4 = FactoryGirl.create(:request, member_uuid: @user.uuid)
  end

  scenario 'a member visits the page' do
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    stub_application_controller
    visit requests_path
    page.should_not have_content @request1.title
    page.should_not have_content @request2.title
    page.should have_content @request3.title
    page.should have_content @request4.title
  end

  scenario 'a mentor visits the page' do
    @user = new_mentor
    @user2 = new_member
    @request1.update(mentor_uuid: @user.uuid)
    @request3.update(mentor_uuid: 'other-mentor-uuid')
    stub_user_fetch_from_uuid
    User.stub(:fetch_from_uuids).and_return({@request3.member_uuid => @user2, @user.uuid => @user, 'member-uuid' => @user2})
    stub_application_controller
    visit requests_path
    page.should have_content @request1.title
    page.should have_content @request2.title
    page.should_not have_content @request3.title
    page.should have_content @request4.title
  end
end

feature 'claim a request' do
  before :each do
    @user = new_mentor
    stub_user_fetch_from_uuid
    stub_application_controller
    @request = FactoryGirl.create(:request)
  end

  scenario 'a mentor claims an open request' do
    visit request_path(@request)
    click_button 'Claim request'
    page.should have_content 'You claimed this request'
  end

  scenario 'a mentor tries to claim an already-claimed request' do
    @request.update(mentor_uuid: 'other-mentor-uuid')
    page.driver.submit :post, claim_requests_path(request_id: @request.id), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a member tries to claim a request' do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    page.driver.submit :post, claim_requests_path(request_id: @request.id), {}
    page.should have_content 'Not authorized'
  end
end

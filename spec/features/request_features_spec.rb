require 'spec_helper'

feature 'create a request' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    visit meeting_requests_path
  end

  scenario 'a member creates a valid request' do
    click_link 'Create a request'
    fill_in 'meeting_request_title', with: 'need help with rails'
    fill_in 'meeting_request_content', with: 'understanding the basics'
    fill_in 'meeting_request_contact_info', with: 'my cell phone for sure'
    click_button 'Submit'
    page.should have_content 'successfully'
  end

  scenario 'a member creates a valid request and tags it with concepts' do 
    concept = FactoryGirl.create(:concept)
    click_link 'Create a request'
    fill_in 'meeting_request_title', with: 'need help with rails'
    fill_in 'meeting_request_content', with: 'understanding the basics'
    fill_in 'meeting_request_contact_info', with: 'my cell phone for sure'
    check(concept.name)
    click_button 'Submit'
    within('#related-concepts') { page.should have_content concept.name }
  end

  scenario 'a member attempts to create an invalid request' do
    click_link 'Create a request'
    click_button 'Submit'
    page.should have_content 'errors'
  end

  scenario 'a mentor attempts to create a request' do
    @user = new_mentor
    stub_application_controller
    visit meeting_requests_path
    page.should_not have_content 'Create a request'
    visit new_meeting_request_path
    page.should have_content 'Not authorized'
    visit meeting_requests_path
    page.driver.submit :post, meeting_requests_path(meeting_request: {title: 'my title', content: 'some content', contact_info: 'get in touch', member_uuid: @user.uuid}), {}
    page.should have_content 'Not authorized'
  end
end

feature 'edit a request' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @meeting_request = FactoryGirl.create(:meeting_request, member_uuid: @user.uuid)
    visit meeting_request_path @meeting_request
  end

  scenario 'a member edits a request with valid information' do
    click_link 'Edit Request'
    fill_in 'meeting_request_title', with: 'new request title'
    click_button 'Submit'
    page.should have_content 'new request title'
  end

  scenario 'they add a concept tag' do 
    concept = FactoryGirl.create(:concept)
    click_link 'Edit Request'
    check(concept.name)
    click_button 'Submit'
    within('#related-concepts') { page.should have_content concept.name }
  end

  scenario 'a member attempts to edit a request with invalid information' do
    click_link 'Edit Request'
    fill_in 'meeting_request_title', with: ''
    click_button 'Submit'
    page.should have_content 'error'
  end

  scenario 'a member who did not create the request attempts to edit the request' do
    @user = new_member
    stub_application_controller
    visit meeting_request_path @meeting_request
    within('.container') {page.should_not have_link 'Edit'}
    visit edit_meeting_request_path @meeting_request
    page.should have_content 'Not authorized'
    visit meeting_requests_path
    page.driver.submit :patch, meeting_request_path(@meeting_request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to edit a request' do
    @user = new_mentor
    stub_application_controller
    visit meeting_request_path @meeting_request
    within('.container') {page.should_not have_link 'Edit'}
    visit edit_meeting_request_path @meeting_request
    page.should have_content 'Not authorized'
    visit meeting_requests_path
    page.driver.submit :patch, meeting_request_path(@meeting_request), {}
    page.should have_content 'Not authorized'
  end
end

feature 'delete a request' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @meeting_request = FactoryGirl.create(:meeting_request, member_uuid: @user.uuid)
    visit meeting_request_path @meeting_request
  end

  scenario 'a member deletes a request' do
    click_link 'Delete'
    page.should_not have_content @meeting_request.title
  end

  scenario 'a member who did not create the request attempts to delete the request' do
    @user = new_member
    stub_application_controller
    visit meeting_request_path @meeting_request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, meeting_request_path(@meeting_request), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a mentor attempts to delete a request' do
    @user = new_mentor
    stub_application_controller
    visit meeting_request_path @meeting_request
    page.should_not have_link 'Delete'
    page.driver.submit :delete, meeting_request_path(@meeting_request), {}
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
    request = FactoryGirl.create(:meeting_request, member_uuid: @user.uuid)
    visit meeting_request_path(request)
    page.should have_content 'Contact Info:'
  end

  scenario 'another member\'s request' do
    request = FactoryGirl.create(:meeting_request)
    visit meeting_request_path(request)
    page.should_not have_content 'Contact Info:'
  end

  scenario 'open request' do
    request = FactoryGirl.create(:meeting_request)
    visit meeting_request_path(request)
    page.should have_content 'Unclaimed'
  end

  scenario 'a request that has been claimed' do
    request = FactoryGirl.create(:meeting_request, mentor_uuid: 'mentor-uuid')
    visit meeting_request_path(request)
    page.should have_content 'Claimed!'
  end
end

feature 'a mentor views a request' do
  before :each do
    @meeting_request1 = FactoryGirl.create(:meeting_request)
    @meeting_request2 = FactoryGirl.create(:meeting_request, mentor_uuid: 'mentor-uuid')
    @user = new_mentor
    stub_application_controller
    stub_user_fetch_from_uuid
  end

  scenario 'open request' do
    request = FactoryGirl.create(:meeting_request)
    visit meeting_request_path(request)
    page.should have_button 'Claim request'
    page.should_not have_content request.contact_info
  end

  scenario 'a request they have claimed' do
    request = FactoryGirl.create(:meeting_request, mentor_uuid: @user.uuid)
    visit meeting_request_path(request)
    page.should have_content 'Claimed!'
    page.should have_content request.contact_info
  end

  scenario 'a request that Claimed! by someone else' do
    request = FactoryGirl.create(:meeting_request, mentor_uuid: 'mentor-uuid')
    visit meeting_request_path(request)
    page.should have_content 'has already been claimed'
    page.should_not have_content request.contact_info
  end
end

feature 'requests index page' do
  before :each do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    @meeting_request1 = FactoryGirl.create(:meeting_request)
    @meeting_request2 = FactoryGirl.create(:meeting_request)
    @meeting_request3 = FactoryGirl.create(:meeting_request, member_uuid: @user.uuid)
    @meeting_request4 = FactoryGirl.create(:meeting_request, member_uuid: @user.uuid)
  end

  scenario 'a member visits the page' do
    stub_user_fetch_from_uuid
    stub_user_fetch_from_uuids
    stub_application_controller
    visit meeting_requests_path
    page.should_not have_content @meeting_request1.title
    page.should_not have_content @meeting_request2.title
    page.should have_content @meeting_request3.title
    page.should have_content @meeting_request4.title
  end

  scenario 'a mentor visits the page' do
    @user = new_mentor
    @user2 = new_member
    @meeting_request1.update(mentor_uuid: @user.uuid)
    @meeting_request3.update(mentor_uuid: 'other-mentor-uuid')
    stub_user_fetch_from_uuid
    User.stub(:fetch_from_uuids).and_return({@meeting_request3.member_uuid => @user2, @user.uuid => @user, 'member-uuid' => @user2})
    stub_application_controller
    visit meeting_requests_path
    page.should have_content @meeting_request1.title
    page.should have_content @meeting_request2.title
    page.should_not have_content @meeting_request3.title
    page.should have_content @meeting_request4.title
  end
end

feature 'claim a request' do
  before :each do
    @user = new_mentor
    stub_user_fetch_from_uuid
    stub_application_controller
    @meeting_request = FactoryGirl.create(:meeting_request)
  end

  scenario 'a mentor claims an open request' do
    visit meeting_request_path(@meeting_request)
    click_button 'Claim request'
    page.should have_content 'Claimed!'
  end

  scenario 'a mentor tries to claim an already-claimed request' do
    @meeting_request.update(mentor_uuid: 'other-mentor-uuid')
    page.driver.submit :post, claim_meeting_requests_path(meeting_request_id: @meeting_request.id), {}
    page.should have_content 'Not authorized'
  end

  scenario 'a member tries to claim a request' do
    @user = new_member
    stub_user_fetch_from_uuid
    stub_application_controller
    page.driver.submit :post, claim_meeting_requests_path(meeting_request_id: @meeting_request.id), {}
    page.should have_content 'Not authorized'
  end
end


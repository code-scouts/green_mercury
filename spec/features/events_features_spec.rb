require 'spec_helper'

feature 'Create an event' do
  before :each do
    @user = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    visit new_event_path
  end

  scenario 'user creates an event with valid information' do
    fill_in 'event_title', with: 'This Thing'
    fill_in 'event_description', with: 'We do things'
    fill_in 'event_location', with: 'That place'
    fill_in 'event_start_time', with: Time.now + 1.hour
    fill_in 'event_end_time', with: (Time.now + 2.hours)
    click_button('Save')
    page.should have_content "Your event has been created."
  end

  scenario 'user creates an event with invalid information' do
    click_button('Save')
    page.should have_content 'error'
  end

  scenario 'event creator should be an organizer by default' do
    fill_in 'event_title', with: 'This Thing'
    fill_in 'event_description', with: 'We do things'
    fill_in 'event_location', with: 'That place'
    fill_in 'event_start_time', with: Time.now + 1.hour
    fill_in 'event_end_time', with: (Time.now + 2.hours)
    click_button('Save')
    within('.display-organizers') { page.should have_content @user.name }
  end
end

feature 'view an event'do
  scenario 'user views an event page' do
    create_mentor_and_event
    stub_user_fetch_from_uuids
    stub_application_controller
    visit event_path(@event)
    page.should have_content @event.title
  end
end

feature 'view all events' do
  scenario 'user views all events' do
    create_mentor_and_event
    stub_user_fetch_from_uuids
    stub_application_controller
    @event2 = FactoryGirl.create(:event, title: 'Event 2')
    visit events_path
    page.should have_content @event.title
    page.should have_content @event2.title
  end
end

feature 'delete an event' do
  before :each do
    create_mentor_and_event
    stub_user_fetch_from_uuids
    stub_application_controller
  end

  scenario 'an event organizer deletes an event' do
    @event.rsvp(@user)
    @event.make_organizer(@user)
    visit event_path @event
    click_link 'Delete event'
    page.should_not have_content @event.title
  end

  scenario 'a non-event organizer attempts to delete an event' do 
    visit event_path @event
    page.should_not have_content 'Delete event'
    page.driver.submit :delete, event_path(@event), {}
    page.should have_content 'Not authorized'
  end
end

feature 'edit an event' do
  before :each do
    create_mentor_and_event
    stub_user_fetch_from_uuids
    stub_application_controller
  end

  scenario 'an event organizer edits an event with valid information' do
    @event.event_rsvps.create(user_uuid: @user.uuid, organizer: true)
    visit event_path @event
    click_link 'Edit event'
    fill_in 'event_location', with: 'That other place'
    click_button('Save')
    page.should have_content "That other place"
  end

  scenario 'an event organizer edits an event with invalid information' do
    @event.event_rsvps.create(user_uuid: @user.uuid, organizer: true)
    visit event_path @event
    click_link 'Edit event'
    fill_in 'event_location', with: ""
    click_button('Save')
    page.should have_content "error"
  end

  scenario 'a non-event organizer tries to edit an event' do
    visit event_path @event
    page.should_not have_content 'Edit event'
    visit edit_event_path @event
    page.should have_content 'Not authorized'
    page.driver.submit :patch, event_path(@event), {}
    page.should have_content 'Not authorized'
  end
end

feature 'RSVP to an event' do
  background 'stub current user with a mentor' do
    @user = FactoryGirl.build(:user, name: 'Peyton')
    FactoryGirl.create(:approved_member_application, user_uuid: @user.uuid) 
    ApplicationController.any_instance.stub(:current_user).and_return(@user)
  end

  background 'create an event' do 
    @event = FactoryGirl.create(:event)
  end

  background "response from Janrain the event's users" do 
    stub_user_fetch_from_uuids    
  end

  background 'visit the event#show page' do 
    visit event_path @event
  end

  background 'RSVP for the event' do 
    click_button 'RSVP for this event'
    expect(@event.rsvp?(@user)).to be_true
    expect(page).to have_content 'Peyton'
  end

  scenario 'user removes their RSVP for an event' do
    click_button 'Cancel RSVP'
    expect(page).to_not have_content @user.name
  end
end

feature 'Add an organizer to an event' do
  before :each do
    @user = new_mentor
    @user2 = new_mentor
    stub_user_fetch_from_uuids
    stub_application_controller
    @event = FactoryGirl.create(:event)
    @event.event_rsvps.create(user_uuid: @user.uuid, organizer: true)
    @event.event_rsvps.create(user_uuid: @user2.uuid)
    visit event_path @event
  end

  scenario 'event organizer adds a new organizer' do
    click_link 'Make organizer'
    expect(@event.organizer?(@user2)).to be_true
  end

  scenario 'non-event organizer tries to add a new organizer' do
    event2 = FactoryGirl.create(:event)
    event2.event_rsvps.create(user_uuid: @user.uuid)
    event2.event_rsvps.create(user_uuid: @user2.uuid)
    visit event_path event2
    page.should_not have_content 'Make organizer'
    page.driver.submit :post, event_organizers_path(event_id: event2.id, user_uuid: @user.uuid), {}
    page.should have_content 'Not authorized'
  end

  scenario 'existing organizers should display under Organizers instead of Attendees' do
    click_link 'Make organizer'
    page.should have_content @user2.name
    page.should_not have_button 'Make organizer'
  end
end

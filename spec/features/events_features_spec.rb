require 'spec_helper'

feature 'create events' do
  before :each do
    # @user = User.new
    # @user.uuid = '1'
    # @user.name = 'Captain Awesome'
    # User.stub(:fetch_from_uuids).and_return({ @user.uuid => @user })
    # EventsController.any_instance.stub(:current_user).and_return(@user)
    visit new_event_path
  end

  scenario 'user creates an event with valid information' do  
    fill_in 'Title', with: 'This Thing'
    fill_in 'Description', with: 'We do things'
    fill_in 'Location', with: 'That place'
    fill_in 'Date', with: Date.today
    fill_in 'Start Time', with: Time.now
    fill_in 'End Time', with: (Time.now + 1.hour)
    click_button('Create Event')
    page.should have_content "Your event has been created."
  end

  scenario 'user creates an event with invalid information' do
    click_button('Create Event')
    page.should have_content 'error'
  end
end
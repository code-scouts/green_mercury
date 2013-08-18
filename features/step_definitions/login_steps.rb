Given(/^I am on the "(.+)" page$/) do |page|
  page_map = {
    signup: new_user_registration_path,
    home: root_path,
  }
  visit page_map[page.to_sym]
end

Given(/^I have a social account$/) do
  @user = FactoryGirl.build :social_user
  @user.confirmed_at = Time.now
end

Given(/^I am signed in$/) do
  login_as(@user, scope: :user)
end


When(/^I fill in "(.+)" with "(.+)"/) do |label, input|
  fill_in label, with: input
end

When(/^I press "(.*?)"$/) do |button|
  click_button button
end


Then(/^the signup form should be shown again$/) do
  current_path.should == user_registration_path
end

Then(/^I should be on the home page$/) do
  current_path.should == root_path
end

Then(/^I should see "(.*?)"$/) do |text|
  begin
    page.should have_content(text)
  rescue
    save_and_open_page
    raise
  end
end

Then(/^"(.+)" should not be registered$/) do |email|
  User.find_by_email(email).should be_nil
end

Then(/^"(.+)" should be registered$/) do |email|
  User.find_by_email(email).should_not be_nil
end

Then(/^"(.+)" should have been sent a confirmation email$/) do |email|
  mails = ActionMailer::Base.deliveries
  mails.length.should == 1
  mails.first.to.should == [email]
  mails.first.subject.should == "Confirm your email address"
end

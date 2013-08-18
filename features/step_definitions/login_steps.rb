Given(/^I am on the signup page$/) do
  visit new_user_registration_path
end


When(/^I fill in "(.+)" with "(.+)"/) do |label, input|
  fill_in label, with: input
end

When(/^I press "(.*?)"$/) do |button|
  click_button button
end

When(/^I sign in with "(.+)"$/) do |provider|
  sleep 30
  find("##{provider.downcase}").click
end


Then(/^the signup form should be shown again$/) do
  current_path.should == user_registration_path
end

Then(/^I should be on the home page$/) do
  current_path.should == root_path
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content(text)
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

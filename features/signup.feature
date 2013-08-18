Feature: Sign up
As an unauthorized user
I want to sign up with my details
So that I can login

Scenario: Password does not match confirmation
  Given I am on the signup page
  When I fill in "Email" with "user@gmail.com"
  And I fill in "Password" with "Secret"
  And I fill in "Password confirmation" with "Password"
  And I press "Sign up"
  Then the signup form should be shown again
  And I should see "Password confirmation doesn't match Password"
  And "user@gmail.com" should not be registered

Scenario: All fields correct
  Given I am on the signup page
  When I fill in "Email" with "user@gmail.com"
  And I fill in "Password" with "supersekrit"
  And I fill in "Password confirmation" with "supersekrit"
  And I press "Sign up"
  Then I should be on the home page
  And I should see "We have sent a message with a confirmation link"
  And "user@gmail.com" should be registered
  And "user@gmail.com" should have been sent a confirmation email


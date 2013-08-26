Feature: events
As an authorized user
I want to create meetup events
So that I can hack with other scouts

@javascript
Scenario: Authorize with Meetup
  Given I have a social account
  And I am signed in
  And I am on the "events" page
  Then I should be redirected to "secure.meetup.com"

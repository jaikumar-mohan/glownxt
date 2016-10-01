Feature: Follower is directly accessible from Companies list

  As a user
  I want click on a 'Companies we found'
  In order to see company information

  @javascript
    Scenario: company name is clicable
      Given a full configured and signed in user
        And another user exists and has a company
        And the user follows the another user, as a 'Companies we found'
      When the user visits its 'Companies we found' or following page
      Then the user should see the another user company with name as link

  @javascript
    Scenario: application information are available from 'Companies we found'
      Given a full configured and signed in user
        And another user exists and has a company
        And the user follows the another user, as a 'Companies we found'
      When the user visits its 'Companies we found' or following page
        And the user clicks on the name of the first 'Companies we found'

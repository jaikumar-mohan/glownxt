Feature: Company Details Page

  As a user
  I would like to view Company details page
  In order to see last updates, related to defined Company

  @javascript
    Scenario: See own dashboard page
      Given a full configured and signed in user
      Given glows exist "current_user"
      When user visits "current_user" dashboard page
        Then user see last glows feed
        And user see "current_user" elevetor pitch, mission, services and product description
      When user scrolls page to the bottom
        Then user see another part of feed

  @javascript
    Scenario: See other user dashboard page
      Given a full configured and signed in user
      Given another user exists
      Given another user exists and has a company
      Given glows exist "other_user"
      When user visits "other_user" dashboard page
        And user see "other_user" elevetor pitch, mission, services and product description
        And user see private glow text_area, button post and button Follow
      When user click button Post
        Then user see message "You can't compose blank Glow!"
       When user write glow
        And user click button Post
        Then user see message "Sent successfully!"
      When user click to comment 19 link
        Then user see input field for comment
        And user write comment for micropost 19 and submite form
        And user see own comment
      Then user delete comment for micropost 19
  

  
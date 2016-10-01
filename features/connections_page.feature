Feature: Connections Page

  As a user
  I would like to view Connections Page
  In order to see GLOWS FEED, ACTIONABLE MARKETING INTELLIGENCE

  @javascript
    Scenario: See connections page
      Given a full configured and signed in user
      Given a update user company params
      Given glows exist "current_user"
      When user visits connections page
        Then user see last glows feed
        And user see wanted tags
        And user see needed tags

  @javascript
  	Scenario: Scroll page, create and delete share glow, update pitch
      Given a full configured and signed in user
      Given glows exist "current_user"
      When user visits connections page
        And user scrolls page to the bottom
        Then user see another part of feed
      When user submite "share glow form"
        Then user see message "You can't compose blank Glow!"
      When user write "share glow" with text= "Micropost 21"
      	And user submite "share glow form"
        Then user see message "Sent successfully!"
        Then user see created glow
      When user delete comment for micropost 21
      	Then user  not see glow with content= Micropost 21

  @javascript
  	Scenario: click links wanted tags, needed tags, companies looked your offer tag, companies offer your loked tag
      Given a full configured and signed in user
      Given a update user company params
      Given 5 companies whith default params
      When user visits connections page
      	And user click link "your company" tag
      	And user see companies "Test company 0, Test company 1, Test company 2, Test company 3, Test company 4"
      When user visits connections page
      	And user click link "other companies" tag
      	And user see companies "Test company 0, Test company 1, Test company 2, Test company 3, Test company 4"

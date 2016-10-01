Feature: Companies Page

  As a user
  I would like to view All registred companies
  I can move other companies page, Search companies by looked tags, offer tags, 
  		by city, by state, by name, by country, write a post to other companies

  @javascript
  	Scenario: scroll page to the bottom
      Given a full configured and signed in user
      Given 20 companies whith default params
      Given 3 company other params
      When user visits companies page
      	Then user see first companies
      When user fill country with "Canada"
      	And user click button search
      	Then user see companies "Other Test company 0, Other Test company 1, Other Test company 2"
     
      
Feature: Contact Page

  As a user
  I would like to write letter to Us

  Scenario: Successful write letter
    When user visits contact page
      And user see first name, last name, email, company and comment fields
    When the user fills all fields= "yes" and email= "valid_email@example.com"
      And the user submits contact form
      And user see message 'Thank you!' and button 'Home'

  @javascript
    Scenario: Unsuccessful write letter
      When user visits contact page
        And user see first name, last name, email, company and comment fields
      When the user fills all fields= "no" and email= "nil"
        And the user submits contact form
        And user see 5 error messages
      When the user fills all fields= "yes" and email= "invalid_email@exampl"
        And the user submits contact form
        And user see error_message Email is invalid

  
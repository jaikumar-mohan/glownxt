

Feature: Signing Up

  #
  # STEP 1 : Contact Information
  #
  @javascript
    Scenario: Successful signup
      Given a user visits the signup page
      When the user fills valid signup information
        And the user submits signup form
      Then new user created
      Then user see "You will receive an email with validation steps in a few minutes"
      Then the user having visited the URL received in the Email Confirmation
        And user see "You are the administrator for Wayne Enterprises"
      When the user submits valid authenticate step form
        Then user redirected to create step page
        And user see "Tell the network about Wayne Enterprises"
      When the user submits valid create step form
        #Then user redirected to dashboard page

  @javascript
    Scenario: Unsuccessful signup because empty mandatory fields
      Given a user visits the signup page
      When the user submits signup form
      Then the user see the Signup page
        And the user see the error message in "first_name" field with text "First name is required"
        And the user see the error message in "last_name" field with text "Last name is required"
        And the user see the error message in "email" field with text "Email is required"
        And the user see the error message in "company_name" field with text "Company name is required"
        And the user see the error message in "password" field with text "Password is required"
      Then the user fill form with short password
      When the user submits signup form
        Then the user see the error message in "password" field with text "Password too short"

  @javascript
    Scenario: Unsuccessful signup because Email already exists
      Given a user visits the signup page
        And another user exists
      When the user fills valid signup information but with Email of another user
        And the user submits signup form
      Then the user see the Signup page
        And the user see the message "has already been taken"

@wip
  Scenario: BUG: Unsuccessful signup with valid Company Name brings Company creation and prevent signup
    Given NotYetImplemented

  #
  # STEP 2 : Email Confirmation
  #
  @javascript @wip
    Scenario: Confirm Email address
      Given a user having submitted a valid signup form
        And the user having visited the URL received in the Email Confirmation
        And user see "Welcome to the network Wayne Enterprises"

  #
  # STEP 3 : Authenticate data
  #
  @wip
  Scenario: Administrator information update
    Given NotYetImplemented
    # And the user confirms by clicking on the "Update" button

  @javascript
    Scenario: Get the elevator pitch and Capabilities tags
      Given a user having confirmed Email address
      When the user enters the elevator pitch "my company is the beast of the world"
        And the user writes "ios, rails, agile" tags as 'Capabilities you offer'
        And the user writes "nosql, community management" tags as 'Capabilities you look for'
        And the user confirms by clicking on the "Next" button
      Then the user goes to the Company edition page
        And click the link Marketing Intellegence
        And the form has "capabilities_offered_list" field with value "agile,rails,ios"
        And the form has "capabilities_lookedfor_list" field with value "community management,nosql"

  #
  # STEP 4 : Create your company record
  @javascript
    Scenario: Get the company details
      Given a user having submitted elevator pitch and Capabilities tags
      When the user writes "Space cake" in the field "company_company_services"
        And the user writes "1007 Mountain Drive" in the field "company[addresses_attributes][0][street]"
        And the user writes "10025" in the field "company[addresses_attributes][0][zip]"
        And the user writes "Gotham" in the field "company[addresses_attributes][0][city]"
        And the user writes "New Jersey" in the field "company_state_id"
        And the user writes "USA" in the field "company_country_id"
        And the user writes "http://example.com" in the field "company[company_website]"
        And the user fills "company_certification_list" with "scrum master, itil" tags
        And the user confirms by clicking on the "Submit" button
      Then the user goes to the Company details page
        And the user see the message "Top Capabilities we offer"
        And the user see the message "ios"
        And the user see the message "rails"
        And the user see the message "agile"
        And the user see the message "Products & Services"
        And the user see the message "Space cake"
      Then the user goes to the Company edit page
        And the user see the message "Certifications your company holds"      
        And the user see the message "scrum"
        And the user see the message "master"
        And the user see the message "itil"

  @wip
  Scenario: Fill Address with invalid or blank values
    Given NotYetImplemented



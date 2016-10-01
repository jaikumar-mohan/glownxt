Feature: Signing in
  
  @javascript
	Scenario: Unsuccessful signin
		Given a user visits the signin page
		When he submits invalid signin information
		Then he see an error message

  @javascript
	Scenario: Successful signin
		Given a user visits the signin page
			And the user has an account
			And the user submits valid signin information
		Then he see a 'not yet validated email' page
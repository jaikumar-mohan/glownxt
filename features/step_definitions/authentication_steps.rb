COMPANY_NAME = "Wayne Enterprises"
OTHER_EMAIL = "robin@gotham.com"

Given /^NotYetImplemented/ do
  pending
end

#
# GIVEN
#
Given /^a user visits the signin page$/ do
  visit new_user_session_path
end
Given(/^a user visits the signup page$/) do
  visit new_user_registration_path
end
Given /^the user has an account$/ do
  @user = User.create!(
    first_name: "Example", 
    last_name: "USER", 
    email: "user@example.com",
    password: "foobarpassword", 
    password_confirmation: "foobarpassword", 
    tos: true, 
    company_name: "Glowfori"
  )
end
Given /^a full configured and signed in user$/ do
  step "the user has an account"
  @user.company.update_attributes(
    company_country: "Switzerland", 
    company_domain: "glowfori.com", 
    company_profile: 'Our Elevator PITCH',
    company_mission: 'Our mission',
    company_services: 'Our service',
    products_description: 'Pur Products description'
  )
  # @user.verify!
  @user.confirmation_sent_at = Time.now()
  @user.confirmed_at = Time.now()
  @user.save

  visit new_user_session_path
  step "the user submits valid signin information"

  # visit root_path
end
Given(/^a user having submitted a valid signup form$/) do
  step "a user visits the signup page"
  step "the user fills valid signup information"
  step "the user submits signup form"
  sleep 1
  @user = User.find_by_email("test@example.com")
end
Given(/^the user having visited the URL received in the Email Confirmation$/) do
  visit edit_email_validation_path(@user, confirmation_token: @user.confirmation_token)
end
Given(/^a user having confirmed Email address$/) do
  step "a user having submitted a valid signup form"
  step "the user having visited the URL received in the Email Confirmation"
end
Given /^a user having submitted elevator pitch and Capabilities tags$/ do
  step "a user having confirmed Email address"
  step "the user enters the elevator pitch \"my company is the beast of the world\""
  step "the user writes \"ios, rails, agile\" tags as 'Capabilities you offer'"
  step "the user writes \"nosql, community management\" tags as 'Capabilities you look for'"
  step "the user confirms by clicking on the \"Next\" button"
end
#
# WHEN
#
When /^he submits invalid signin information$/ do
  click_button "Sign In"
end
When /^the user submits valid signin information$/ do
  fill_in "user_email",    with: @user.email
  fill_in "user_password", with: @user.password
  click_button "Sign In"
end
When(/^the user fills valid signup information$/) do
  fill_in "user_first_name",            with: "Bruce"
  fill_in "user_last_name",             with: "WAYNE"
  fill_in "user_email",                 with: "test@example.com"
  fill_in "user_password",              with: "batmanpass"
  fill_in "user_password_confirmation", with: "batmanpass"
  fill_in "user_company_name",          with: COMPANY_NAME
  check 'user_tos'
end
When(/^the user submits valid authenticate step form$/) do
  fill_in "user[first_name]",            with: "Bruce"
  fill_in "user[last_name]",             with: "WAYNE"
  fill_in "user[email]",                 with: "test@example.com"
  fill_in "user[company_attributes][company_profile]",              with: "My PITCH"

  page.execute_script("$('#user_company_attributes_capabilities_offered_list').val('Rails, Redis, Rescue')")
  page.execute_script("$('#user_company_attributes_capabilities_lookedfor_list').val('HTML, CSS, JQUERY')")

  click_button 'Next'
  # @user.verify!
  @user.confirmation_sent_at = Time.now()
  @user.confirmed_at = Time.now()
  @user.save
end
When(/^the user submits valid create step form$/) do
  fill_in "company[addresses_attributes][0][street]",            with: "Test Street"
  fill_in "company[addresses_attributes][0][zip]",             with: "12345"
  fill_in "company[addresses_attributes][0][city]",                 with: "Test City"
  page.execute_script("$('#company_state_id').val('1')")
  # fill_in "company[addresses_attributes][0][state_id]",              with: "Test State"
  
  # fill_in "company[addresses_attributes][0][country_id]",              with: "Test Country"
  page.execute_script("$('#company_country_id').val('1')")
  fill_in "company[company_website]",              with: "example.com" 

  page.execute_script("$('#company_company_certification_list').val('railsconf, maincertificate')")

  fill_in "company[company_services]", with: 'Test services'
  fill_in "company[products_description]", with: 'Test description'
  click_button 'Submit'
end
When(/^the user submits signup form$/) do
  click_button "Submit"
  sleep 1
end
When(/^the user fills valid signup information but with Email of another user$/) do
  step "the user fills valid signup information"
  fill_in "user_email",                 with: @other_user.email
end
When(/^the user fills valid signup information but with Email Confirmation different$/) do
  step "the user fills valid signup information"
  fill_in "user_email_confirmation",    with: OTHER_EMAIL
end
When(/^the user confirms by clicking on the button$/) do
  click_button "Confirm email"
end
When(/^the user confirms by clicking on the "([^"]*)" button$/) do |button_id|
  click_button button_id
end
When(/^the user enters the elevator pitch "([^"]*)"$/) do |pitch|
  fill_in "user[company_attributes][company_profile]",       with: pitch
end
When /^the user writes "(.*?)" tags as 'Capabilities you offer'$/ do |tags|
  page.execute_script("$('#user_company_attributes_capabilities_offered_list').val('#{tags}')")
end
When /^the user writes "(.*?)" tags as 'Capabilities you look for'$/ do |tags|
  page.execute_script("$('#user_company_attributes_capabilities_lookedfor_list').val('#{tags}')")
end
When /^the user writes "([^"]*)" tags as Company Certifications$/ do |tags|
  fill_in "company[company_certification_list]",  with: tags
end
When /^the user writes "(.*?)" in the field "(.*?)"$/ do |value, field|
  if field == "company_state_id"
    page.execute_script("$('##{field}').val('1')")
  elsif field == "company_country_id"
    page.execute_script("$('##{field}').val('1')")
  elsif field == "company_company_services"
    find('textarea#company_company_services').set value
  else
    fill_in field, with: value
  end 
end
When /^the user confirms by clicking on the "([^"]*)" link$/ do |name|
  click_link name
end

#
# THEN
#
Then /^he see an error message$/ do
  page.should have_selector('div.error-text')
end
Then /^he see a 'not yet validated email' page$/ do
  page.should have_content('Your email has not been verified')
end
Then /^he see his profile page$/ do
  page.should have_selector('title', text: @user.full_name)
end
Then /^he see a signout link$/ do
  page.should have_link('Sign out', href: signout_path)
end
Then(/^the user see the home page$/) do
  current_path.should == root_path
  page.should have_content("Home to the connected companies. Finding trusted quality partners the first time.")
end
Then(/^the user see a "([^"]*)" alert with message "([^"]*)"$/) do |level, message|
  page.should have_css("div.alert.alert-#{level}", message)
end
Then(/^the user see the Signup page$/) do
  current_path.should == new_user_registration_path
  page.should have_css("h3", "Sign up")
end
Then(/^the user see the message "([^"]*)"$/) do |message|
  page.should have_content(message)
end
Then(/^the user see the error message in "([^"]*)" field with text "([^"]*)"$/) do |field_name, error_message|
  basepath = "input[name='user[" + field_name + "]']"
  find(basepath).find(:xpath, '..').find(:xpath, '..').find('.error-text').should have_content(error_message)
end
Then(/^the user see a field with the First Name he wrote$/) do
  find_field("user_first_name").value.should == @user.first_name
end
Then(/^the user see a field with the Last Name he wrote$/) do
  find_field("user_last_name").value.should == @user.last_name
end
Then(/^the user see a field with the Email he wrote$/) do
  find_field("user_email").value.should == @user.email
end
Then(/^the user see a field with the Email Confirmation he wrote$/) do
  find_field("user_email_confirmation").value.should == OTHER_EMAIL
end
Then(/^the user see a field with the Company Name he wrote$/) do
  find_field("user_company_name").value.should == COMPANY_NAME
end
Then(/^the user see the Authenticate Data page$/) do
  current_path.should == user_path(:pitching)
  page.should have_css("h3", "Company profile set-up")
end
Then(/^the user see the Company Name he wrote$/) do
  page.should have_content(COMPANY_NAME)
end
Then(/^the user see the Glowfile Creation page$/) do
  # current_path.should == user_path(:glowfile)
  current_path.should == companies_path(@user.company).gsub(".", "/")
  # step "NotYetImplemented"
#  a_company = @user.company
#  current_path.should == company_path(a_company)
#  page.should have_css("h3", "Tell the network about: #{COMPANY_NAME}")
end
Then /^the user see the Company signup detail page$/ do
  current_path.should == user_path(:company)
end
Then /^the user see the Company page$/ do
  current_path.should == company_path(@user.company)
end

Then /^user redirected to create step page$/ do
  sleep 1
  current_path.should == pitching_users_path
end

Then /^user redirected to dashboard page$/ do
  current_path.should == final_step_users_path
end

Then /^user see "(.+)"$/ do |message|
  page.should have_content(message)
end

Then /^new user created$/ do
  sleep 1
  @user = User.find_by_email("test@example.com")
  @user.id.should_not be_nil
end

Then /^the user goes to the Company edition page$/ do
  sleep 1
  visit edit_company_path(@user.company.id)
end

Then /^the user goes to the Company details page$/ do
  sleep 1
  visit company_path(@user.company)
end

Then(/^the user fill form with short password$/) do
  fill_in "user[password]", with: '123'
end

Then(/^the form has "(.*?)" field with value "(.*?)"$/) do |id_postfix, value|
  sleep 1
  find(:xpath, "//input[@id='company_" + id_postfix + "']").value.should include(value)
end

When(/^the user fills "(.*?)" with "(.*?)" tags$/) do |name, tags|
  page.execute_script("$('#company_#{name}').val('#{tags}')")
end

Then(/^click the link Marketing Intellegence$/) do
  page.execute_script("$('[data-content=company_marketing]').click()")
end

When(/^stop$/) do
  sleep 20
end

Then(/^the user goes to the Company edit page$/) do
  visit edit_company_path(@user.company)
end

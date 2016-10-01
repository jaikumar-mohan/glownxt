When(/^user visits contact page$/) do
  visit new_contact_path
end

When(/^user see first name, last name, email, company and comment fields$/) do
  [ "#contact_first_name", "#contact_last_name", "#contact_company", "#contact_email", "#contact_body" ].each do | id |
    page.should have_css(id)
  end
end

When(/^the user fills all fields= "(.*?)" and email= "(.*?)"$/) do |all_fields, email|
  if all_fields == 'yes'
    fill_in "contact[first_name]",            with: "Bruse"
    fill_in "contact[last_name]",             with: "Waine"
    fill_in "contact[company]",         	   	with: "company_name"
    find("#contact_body").set                 "#{Faker::Lorem.paragraph}" 
  end
  fill_in "contact[email]",                 with: email if email != "nil"
end

When(/^the user submits contact form$/) do
  click_button "Submit"
end

When(/^user see message 'Thank you!' and button 'Home'$/) do
  page.should have_content("Thank you! Your message has been sent and will be reviewed as soon as possible.")
  page.should have_css('a.btn.btn-primary')
end

When(/^user see error_message Email is invalid$/) do
  page.should have_content("Email is invalid")
end

When(/^user see 5 error messages$/) do
  ["First name is required", "Last name is required", "Email is required", "Company is required", "Comments is required"].each do | error |
    page.should have_content(error)
  end
end

#
# GIVEN
#


#
# WHEN
#
When /^the user visits its 'Companies we found' or following page$/ do
  visit following_user_path(@user)
end

When /^the user clicks on the name of the first 'Companies we found'$/ do
  page.should have_content @other_company.user.full_name
end


#
# THEN
#
Then /^the user should see the another user company with name as link$/ do
  page.should have_content(@other_company.user.first_name)
  page.should have_content(@other_company.user.last_name)
end

Then /^the user see the company information page$/ do
  current_path.should == company_path(@other_company)
  page.should have_content(@other_company.company_name)
  page.should have_content(@other_company.company_profile)
  page.should have_content(@other_company.company_mission)
  page.should have_content(@other_company.company_services)    
  page.should have_content(@other_company.products_description)
end

Then /^the user see the Company edition page$/ do
  current_path.should == edit_company_path(@user.company)
end
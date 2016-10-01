#
# GIVEN
#
Given /^another user exists$/ do
  @other_user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: FactoryGirl.generate(:email),
    password: "password1",
    password_confirmation: "password1",
    tos: true,
    company_name: FactoryGirl.generate(:company_name),
    confirmation_sent_at: Time.now(),
    confirmed_at: Time.now())
end

Given /^another user exists and has a company$/ do
  step "another user exists"
  @other_user.company.update_attributes(company_country: "Switzerland", company_domain: "inagua2.ch")
  @other_company = @other_user.company
end

Given /^the user follows the another user, as a 'Companies we found'$/ do
  @user.follow!(@other_user)
end


#
# WHEN
#


#
# THEN
#

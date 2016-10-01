When(/^user visits companies page$/) do
  visit companies_path
end

Then(/^user see first companies$/) do
  ( 0..9 ).each do |i|
    page.should have_content("Test company #{i}")
  end
end

Then(/^user see another part of companies$/) do
  ( 10..19 ).each do |i|
    page.should have_content("Test company #{i}")
  end
end

When(/^user put cursor on the table$/) do
  find("tr#company_3").click()
end

When(/^user scrolls table to the bottom$/) do
  page.execute_script "$('table').scrollBy(0,10000)" 
end

Given(/^(\d+) company other params$/) do |number|
  country1 = FactoryGirl.create(:country)
  country2 = FactoryGirl.create(:country, name: "Canada")

  FactoryGirl.create(:state, country_id: country1.id)
  FactoryGirl.create(:state, country_id: country2.id, name: "Calgary")

  number.to_i.times do |n|
    user = FactoryGirl.create(:user)
    user.company.update_attributes(
      company_name: "Other Test company #{n}",
      company_country: "Canada", 
      company_website: "http://example.com", 
      company_profile: "Lorem Ipsum", 
      capabilities_offered_list: ['haml', 'agile', 'sass'].join(', '), 
      capabilities_lookedfor_list: ['html', 'java'].join(', ')
    )
    user.company.primary_address.update_attributes(
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '416 Water St. ',
      city: 'Calgary',
      zip: '10002',
      state_id: 2,
      country_id: 2
    )
  end
end

When(/^user fill country with "(.*?)"$/) do |country|
  find("#country_id").set                 country 
  find('.ui-menu-item a').click()
end

When(/^user click button search$/) do
  page.execute_script("$('.search_by_companies').submit()")
end

When(/^user fill city with "(.*?)"$/) do |city|
  find("#by_city").set                 city 
end



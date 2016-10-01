Given(/^a update user company params$/) do
  @user.company.update_attributes(
    capabilities_lookedfor_list: ['html', 'haml', 'java'].join(', '),
    capabilities_offered_list: ['sql', 'css'].join(', '),
    company_certification_list: [ 'Rails COnf 2013', 'Ajax solutions sertificate', 'ASX Group Cert 2011'].join(', ')
  )
end

Given(/^(\d+) companies whith default params$/) do |number|
  number.to_i.times do |n|
    user = FactoryGirl.create(:user)
    user.company.update_attributes(
      company_name: "Test company #{n}",
      company_country: "United States", 
      company_website: "http://example.com", 
      company_profile: "Lorem Ipsum", 
      capabilities_offered_list: ['redis', 'sql', 'mysql', 'php', 'java'].join(', '), 
      capabilities_lookedfor_list: ['html', 'css', 'haml', 'slim', 'sass'].join(', ')
    )
    user.company.primary_address.update_attributes(
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '416 Water St. ',
      city: 'New York',
      zip: '10002',
      state_id: 1,
      country_id: 1
    )
  end
end

When(/^user visits connections page$/) do
  visit connections_path
end

Then(/^user see wanted tags$/) do
  @user.company.top_capabilities_wanted_right_now(false).each do |tagname, count|
    page.should have_content(tagname)
  end
end

Then(/^user see needed tags$/) do
  @user.company.top_capabilities_needed_right_now(false).each do |tagname, count|
    page.should have_content(tagname)
  end
end

When(/^user submite "(.*?)"$/) do |form|
  form = "$('form#new_micropost')"
  page.execute_script("#{form}.submit()")
end

When(/^user write "(.*?)" with text= "(.*?)"$/) do |textarea, text|
  textarea = "textarea#micropost_content"
  find(textarea).set  text
end

Then(/^user see created glow$/) do
  page.should have_content("Micropost 21")
end

Then(/^user  not see glow with content= Micropost 21$/) do
  page.should_not have_content("Micropost 21")
end

When(/^user click link "(.*?)" tag$/) do |type|
  if type == "your company"
    type = '.b-connections__table-labels a'
    page.execute_script("
      var searchText = 'sql';
      $('#{type}').children('div:contains('+ searchText +')').click();
      
    ")
  else
    type = ".b-actionable-intel__link"
    page.execute_script("
      var aTags = $('#{type}');
      var searchText = 'css';

      for (var i = 0; i < aTags.length; ++i) {
        if (aTags[i].textContent == searchText) {
            aTags[i].click();
          break;
        }
      }
    ")
  end
end

Then(/^user see content "(.*?)"$/) do |tag|
  page.should have_content(tag)
end

Then(/^user see companies "([^"]*)"$/) do |companies|
  companies.split(',').each do |company|
  	page.should have_content(company)
  end
end
Given(/^glows exist "(.*?)"$/) do |param|
  user = (param == 'current_user' ? @user : @other_user)
  20.times do |i|
    FactoryGirl.create(:micropost, 
      user: user,
      to: user,
      content: "Micropost #{i + 1}"
    )
  end
end

When(/^user visits "(.*?)" dashboard page$/) do |param|
  user = param == 'current_user' ? @user : @other_user
  visit company_path(user.company)
end

Then(/^user see last glows feed$/) do
  ( 11..20 ).each do |i|
    page.should have_content("Micropost #{i}")
  end
end

Then(/^user see "(.*?)" elevetor pitch, mission, services and product description$/) do |param|
  user = param == 'current_user' ? @user : @other_user
  @company = user.company
  [ @company.company_profile, @company.company_mission, @company.company_services, @company.products_description ].each do | content |
    page.should have_content(content)
  end
end

When(/^user scrolls page to the bottom$/) do
  page.execute_script "window.scrollBy(0,10000)" 
end

Then(/^user see another part of feed$/) do
  ( 1..10 ).each do |i|
    page.should have_content("Micropost #{i}")
  end
end

Then(/^user see private glow text_area, button post and button Follow$/) do
  page.should have_css(".s-btn-warning")
  page.should have_css(".s-btn.btn")
  page.should have_css('#micropost_content')
end

When(/^user click button Post$/) do
  page.execute_script("$('#new_micropost').submit()")
end

Then(/^user see message "(.*?)"$/) do |message|
  page.should have_content(message)
end

When(/^user write glow$/) do
  find("form.b-post-form textarea").set "#{Faker::Lorem.paragraph}"
end

When(/^user click to comment (\d+) link$/) do |num|
  page.execute_script("$('li#micropost_#{num} .js-comments-create-link').click()")
end

Then(/^user see input field for comment$/) do
  page.should have_css('form.js-comments-form')
end

Then(/^user write comment for micropost (\d+) and submite form$/) do |num|
  @comment = Faker::Lorem.word
  page.execute_script("$('li#micropost_#{num} input').val('#{ @comment }')")
  page.execute_script("$('li#micropost_#{num} form').submit()")
end

Then(/^user see own comment$/) do
  page.should have_content("#{ @user.company_name }")
  page.should have_content("#{ @comment }")
  page.should have_css(".js-comments-destroy-link")
end

When(/^user delete comment for micropost (\d+)$/) do |num|
  page.execute_script("$('form#edit_micropost_#{num} a.js-comments-destroy-link').click()")
end






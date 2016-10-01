FactoryGirl.define do

	factory :user do
    sequence(:first_name)  { |n| "Person_#{n}" }
    sequence(:last_name)  { |n| "NAMED_#{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}
		password "foobarpass"
		password_confirmation "foobarpass"
    tos true
    sequence(:company_name) { |n| "Company #{n}" }
    confirmation_sent_at Time.now()
    confirmed_at Time.now()

		factory :admin do
			admin true
		end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
    parent_id ""
  end

  factory :userToReplyTo, class: User do | user |
    user.first_name "Donald"
    user.last_name "DUCK"
    user.email "test@example.com"
    user.password "foobarpass"
    user.password_confirmation "foobarpass"
    user.tos true
    user.company_name { |n| "Company #{n}" }
    user.confirmation_sent_at Time.now()
    user.confirmed_at Time.now()
  end

  factory :micropost_to_donald do | micropost |
    micropost.content "@donald bla bla bla"
    micropost.user :user
  end

  factory :company do
    sequence(:company_name)   { |n| "Company #{n}" }
    company_country "United States" 
    company_website "http://example.com" 
    company_profile "Lorem Ipsum" 
    capabilities_offered_list ['redis', 'sql', 'mysql', 'php', 'java'].join(', ') 
    capabilities_lookedfor_list ['html', 'css', 'haml', 'slim', 'sass'].join(', ')
  end

  factory :country do
    name 'United States'
  end

  factory :state do
    name 'New York'
    country_id 1
  end

  sequence :company_name do |n|
    "company #{n}"
  end

  sequence :email do |n|
    "person_#{n}@example.com"
  end
end
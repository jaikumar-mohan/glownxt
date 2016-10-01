require 'csv'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    populate_countries!
    add_tags!
    make_admin!
    make_unverified_user!
    make_users!
    make_microposts!
    make_relationships!
    add_blog_posts!
  end
end

def capabilities_offered_list
  [ 'ruby on rails', 'rescue', 'redis', 'mongodb', 'sql', 'mysql', 'php', 'java', 'scala', 'android', 'iphone', 'ios', 'agile', 'scrum', 'sprint planning', 'websockets', 'ajax', 'backbone.js', 'ember.js' ]
end

def capabilities_lookedfor_list
  [ 'html', 'css', 'haml', 'slim', 'scss', 'sass', 'photoshop', 'web design', 'adobe illustrator', 'dreamviewer', 'flash', 'magento', 'padrino', 'sinatra', 'merb', 'administration', 'project management' ]
end

def company_certification_list
  [ 'Rails COnf 2013', 'Ajax solutions sertificate', 'ASX Group Cert 2011', 'Mongo DB 2010', 'RubyCOnf 2012', 'HTML&CSS for professionals', 'HAMLMOnsters 2013', 'Backbone & CO', 'Ember Solutions', 'Rails Best Practices' ]
end

def address_samples
  us = Country.find_by_name('United States')
  ny = us.states.find_by_name('New York')
  wyoming = us.states.find_by_name('Wyoming')
  ohio = us.states.find_by_name('Ohio')

  new_york = { 
    state_id:  ny.id,
    country_id: us.id
  }  

  [ 
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '45 Park Avenue',
      city: 'New York',
      zip: '10016',
      state_id: ny.id,
      country_id: us.id
    },
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '300 West F Street',
      city: 'Casper',
      zip: '82601',
      state_id: wyoming.id,
      country_id: us.id
    },
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '466 South TrimbleRoad',
      city: 'Mansfield',
      zip: '44906',
      state_id: ohio.id,
      country_id: us.id
    }
  ]        
end

def make_admin!
  admin = User.create!(
    first_name: "Exemple",
    last_name: "USER",
    email: "example@glowfori.com",
    password: "password",
    password_confirmation: "password",
    company_name: 'glowfori management team',
    tos: true) unless User.exists?(email: "example@glowfori.com")

  if admin.present?
    admin.confirm!
    admin.toggle!(:admin)
    update_company_base_information!(admin.company)
    add_address_to_company!(admin.company)
  end
end

def make_unverified_user!
  unless User.exists?(email: 'unverified@glowfori.com')
    User.create!(
      first_name: "Unverified",
      last_name: "USER",
      email: "unverified@glowfori.com",
      password: "password",
      password_confirmation: "password",
      company_name: 'unverified_test_copmany',
      tos: true)
  end
end

def make_users!
  20.times do |n|
    email = "example-#{n+1}@glowfori.com"

    unless User.exists?(email: email)
      user = create_user!(email)
      company = user.company     
      update_company_base_information!(company)
      add_address_to_company!(company)
      add_microposts_and_comments_to_company!(company, user)      
    end
  end
end

def create_user!(email)
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: email,
    password: "password",
    password_confirmation: "password",
    tos: true,
    company_name: generate_uniq_company_name)

  user.confirm!
  user
end

def generate_uniq_company_name
 Faker::Name.first_name + " #{Company.last.id + 1}"
end

def update_company_base_information!(company)
  if company.id.odd?
    c_offered_list = capabilities_offered_list.sample(5).join(', ')
    c_lookedfor_list = capabilities_lookedfor_list.sample(5).join(', ')
  else
    c_offered_list = capabilities_lookedfor_list.sample(5).join(', ')
    c_lookedfor_list = capabilities_offered_list.sample(5).join(', ')
  end

  company.update_attributes(
    company_profile: "Our Pitch: #{Faker::Lorem.paragraph}", 
    company_mission: "Our mission: #{Faker::Lorem.paragraph}", 
    company_services: "Our services: #{Faker::Lorem.paragraph}", 
    company_website: "http://example.com",  
    capabilities_offered_list: c_offered_list, 
    capabilities_lookedfor_list: c_lookedfor_list,
    company_certification_list: company_certification_list.sample(5).join(', '), 
    products_description: "Our products: #{Faker::Lorem.paragraph}"
  )
end

def add_address_to_company!(company)
  address_attrs = address_samples[rand(0..2)]
  address = company.primary_address

  if address.persisted?
    address.update_attributes(address_attrs)
  else
    address.attributes = address_attrs
    address.save!
  end
end

def add_microposts_and_comments_to_company!(company, user)
  6.times do
    micropost = company.user.microposts.create!(
      user_id: user.id,
      content: Faker::Lorem.paragraph[0..139]
    )

    [ 1, 2 ].sample.times do 
      micropost.children.create!(
        user_id: User.first(order: "RANDOM()").id,
        content: Faker::Lorem.paragraph[0..139]
      )
    end
  end  
end

def make_microposts!
  users = User.limit(100)
  10.times do
    content = Faker::Lorem.sentence(5)[0..139]
    users.each do |user| 
      user.microposts.create!(content: content)
    end
  end
end

def make_relationships!
  users = User.all
  user = users.first
  followed_users = users[2..10]
  followers = users[3..12]

  followed_users.each do |followed| 
    user.follow!(followed) if user.can_follow?(followed)
  end

  followers.each do |follower| 
    follower.follow!(user) if follower.can_follow?(user)
  end
end

def add_blog_posts!
  admin = User.where(email: 'example@glowfori.com').first

  if Entry.count.zero?
    30.times do
      admin.entries.create!(
        title: Faker::Lorem.sentence,
        brief: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraphs.join(' ')
      )
    end
  end
end

def add_tags!
  #tags source: #http://data.stackexchange.com/stackoverflow/query/3978/most-popular-stackoverflow-tags-in-may-2010
  CSV.open("#{Rails.root}/lib/tasks/data/tags.csv", 'r').each do |row|
    ActsAsTaggableOn::Tag.find_or_create_by_name row[0]
  end
  
  puts "Tags count : #{ActsAsTaggableOn::Tag.count}"  
end

def populate_countries!
  Rake::Task["db:populate_countries"].invoke
end
module Companies
  def company_address_default
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '416 Water St. ',
      city: 'New York',
      zip: '10002',
      state_id: 1,
      country_id: 1
    }
  end

  def test_company1_address
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '416 Water St. ',
      city: 'New York',
      zip: '10002',
      country_id: 2, 
      state_id: 3
    }
  end

  def test_company2_address
    {
      tel: "#{Faker::PhoneNumber.cell_phone}",
      street: '416 Water St. ',
      zip: '10002',
      city: 'Calgary',
      country_id: 2, 
      state_id: 3
    }
  end

  def company_attributes_default
    {
      company_country: "United States", 
      company_website: "http://example.com", 
      company_profile: "Lorem Ipsum", 
      capabilities_offered_list: ['redis', 'sql', 'mysql', 'php', 'java'].join(', '), 
      capabilities_lookedfor_list: ['html', 'css', 'haml', 'slim', 'sass'].join(', ')
    }
  end

  def test_company1_attributes
    {
      company_name: FactoryGirl.generate(:company_name), 
      company_country: "Canada", 
      company_profile: "1 Pitch",
      capabilities_lookedfor_list: ['html', 'haml', 'java'].join(', '),
      capabilities_offered_list: ['sql', 'css'].join(', '),
      company_certification_list: [ 'Rails COnf 2013', 'Ajax solutions sertificate', 'ASX Group Cert 2011'].join(', ')
    }
  end

  def test_company2_attributes
    {
      company_profile: "Lorem Ipsum",
      company_country: "Canada",
      capabilities_lookedfor_list: ['html', 'haml', 'java'].join(', '),
      capabilities_offered_list: ['sql', 'css', 'slim'].join(', ')
    }
  end

  def test_company3_attributes
    {
      company_profile: '10 Pitch',
      capabilities_lookedfor_list: ['html', 'css', 'haml', 'slim', 'sass'].join(', ')
    }
  end

  def add_n_company(n, company_attrs = company_attributes_default , company_address_attrs = company_address_default)
    n.times do
      user = FactoryGirl.create(:user)
      user.company.update_attributes(company_attrs)
      user.company.primary_address.update_attributes(company_address_attrs)
    end
  end

  def update_current_user_company(current_user, company_attrs = company_attributes_default)
    current_user.company.update_attributes(company_attrs)
  end

  def add_some_locations(country_name, state_name)
    country = Country.create!(name: country_name)
    country.states.create!(name: state_name)
  end

  def update_company_with_offer_and_looked_tags_and_location(user, offer_tags, lookedfor_tags, country_name, state_name, city)
    company_attrs = company_attributes_default
    company_attrs[:capabilities_offered_list] = offer_tags
    company_attrs[:capabilities_lookedfor_list] = lookedfor_tags

    user.company.update_attributes(company_attrs)

    company_address_attrs = company_address_default

    country = Country.find_by_name(country_name)
    company_address_attrs[:country_id] = country.id
    company_address_attrs[:state_id] = country.states.find_by_name(state_name).id
    company_address_attrs[:city] = city

    user.company.primary_address.update_attributes(company_address_attrs)
  end

  def add_n_companies_with_offer_and_looked_tags_and_location(n, offer_tags, lookedfor_tags, country_name, state_name, city)
    n.times do
      user = FactoryGirl.create(:user)
      update_company_with_offer_and_looked_tags_and_location(user, offer_tags, lookedfor_tags, country_name, state_name, city)
    end    
  end
end
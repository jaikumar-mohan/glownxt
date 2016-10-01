module CountiesAndStates
  def add_countries
  	FactoryGirl.create(:country, name: 'United Arab Emirates')
    FactoryGirl.create(:country, name: 'Peru')
    FactoryGirl.create(:country, name: 'United Kingdom')
    FactoryGirl.create(:country, name: 'Mali')
    FactoryGirl.create(:country, name: 'Ukraine Kingdom')
    FactoryGirl.create(:country, name: 'Uganda')
  end

  def add_states_for_country(country)
  	FactoryGirl.create(:state, country_id: country.id)
    FactoryGirl.create(:state, country_id: country.id, name: 'Nebraska')
    FactoryGirl.create(:state, country_id: country.id, name: 'Nevada' )
    FactoryGirl.create(:state, country_id: country.id, name: 'Maine')
    FactoryGirl.create(:state, country_id: country.id, name: 'Kansas')
  end

end
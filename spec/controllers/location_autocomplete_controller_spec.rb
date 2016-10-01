require 'spec_helper'


describe LocationAutocompleteController do

  include CountiesAndStates

  let!(:country) { FactoryGirl.create(:country) }

  describe "Autocomplite country and states with Ajax" do
    before { 
      add_countries
      add_states_for_country(country)
    }

    it "should respond 5 Countries with the letter 'u'" do
      xhr :get, :index, term: "u"
      assigns(:countries).count.should eq(5)
    end

    it "Autocomplite country should respond with success" do
      xhr :get, :index, term: "u"
      response.should be_success
    end

    it "should respond 3 States with the letter 'n'" do
      xhr :get, :states, country_id: country.id, term: "n" 
      assigns(:states).count.should eq(3)
    end

    it "should respond 0 States with the letter 'z'" do
      xhr :get, :states, country_id: country.id, term: "z" 
      assigns(:states).count.should eq(0)
    end

    it "Autocomplite states should respond with success" do
      xhr :get, :states, country_id: country.id, term: "n" 
      response.should be_success
    end
  end
end
require 'spec_helper'

describe ConnectionsController, js: true do
  include Companies
  include Microposts

  let!(:user) { FactoryGirl.create(:user) }
  before { 
    sign_in(user)

    add_some_locations('United States', 'New York')

    update_company_with_offer_and_looked_tags_and_location(user, 'rails, ruby, rescue', 'html, css, design', 'United States', 'New York', 'New York')
 
    # add 4 companies that are looking for capability user offers (rails) and offers capabilities user looking for (html, css)
    add_n_companies_with_offer_and_looked_tags_and_location(4, 'html, css, photoshop', 'rails, agile', 'United States', 'New York', 'Geneva')

    # add 3 companies that are looking for capability user offers (rails) and offers capability user looking for (css) in same city
    add_n_companies_with_offer_and_looked_tags_and_location(3, 'css, sass, haml', 'ruby, amazon', 'United States', 'New York', 'New York')

    # add 2 companies that are looking for capability user offers (rescue)
    add_n_companies_with_offer_and_looked_tags_and_location(2, 'photoshop, webdesign', 'rescue, scrum, agile', 'United States', 'New York', 'Amsterdam')

    # add 1 company that are offers capability user looking for (design) in a same city
    add_n_companies_with_offer_and_looked_tags_and_location(1, 'design, photoshop', 'scrum, agile', 'United States', 'New York', 'New York')    
  }

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns 3 top_wanted_capabilities" do
      get 'index'
      assigns(:top_wanted_capabilities_not_glow).count.should eq(3)
    end

    it "returns 3 top_needed_capabilities" do
      get 'index'
      assigns(:top_needed_capabilities_not_glow).count.should eq(3)
    end

    it "returns proper actionable marketing intelligence blocks" do
      get 'index'
      assigns(:companies_looking_for_capabilities_you_offer).should eq(9)
      assigns(:most_sought_capability_tou_offer).should == 'rails'
      assigns(:companies_looking_for_capabilities_you_offer_in_same_city).should eq(3)
      assigns(:companies_offer_capabilities_you_looking_for).should eq(8)
      assigns(:most_offered_capability_that_you_looking_for).should == 'css'
      assigns(:companies_offer_capabilities_you_looking_for_in_same_city).should eq(4)
    end

  end

  describe "load companies with Ajax" do 	  
    before {
      add_n_microposts(1, user, "1 micropost") 

      add_n_microposts(8, user)

      add_n_microposts(1, user, "10 micropost")

      add_n_microposts(10, user)

      xhr :get, :load,  page: 2
    }

    it "should respond with 10 Microposts" do
      assigns(:microposts).should have(10).Micropost
    end

    it "should first Micropost content_text '10 micropost'" do
      assigns(:microposts).first.content.should eq('10 micropost')
    end

    it "should last Micropost content_text '1 micropost'" do
      assigns(:microposts).last.content.should eq('1 micropost')
    end

    it "should respond with success" do
      response.should be_success
    end
  end

end
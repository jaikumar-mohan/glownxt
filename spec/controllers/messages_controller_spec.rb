require 'spec_helper'


describe MessagesController, js: true do

  include Companies

  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  before { 
    sign_in user
    update_current_user_company(user, test_company1_attributes)
  }

  describe "creating a message with Ajax" do
    it "should increment the Message count" do
      expect do
        xhr :post, :create, company_id: other_user.company.id, micropost: { content: "foobar" }
      end.to change(Micropost, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, company_id: other_user.company.id, micropost: { content: "foobar" }
      response.should be_success
    end
    
    it "Send micropost_content = empty should micropost not create" do
      expect do
        xhr :post, :create, company_id: other_user.company.id, micropost: { content: "" }
      end.to_not change(Micropost, :count).by(1)
    end
  end

  describe "mass_sending messages with Ajax" do
    let!(:other_user2) { FactoryGirl.create(:user) }
    let!(:other_user3) { FactoryGirl.create(:user) }

    it "should increment the Message count" do
      expect do
        xhr :post, :mass_sending, recepients: "#{other_user.company.id}, #{other_user2.company.id}, #{other_user3.company.id}", 
          micropost: { content: "Hello, TEST private GLOW" }
      end.to change(Micropost, :count).by(3)
    end

    it "should respond with success" do
      xhr :post, :mass_sending, recepients: "#{other_user.company.id}, #{other_user2.company.id}, #{other_user3.company.id}", 
        micropost: { content: "Hello, TEST private GLOW" }
      response.should be_success
    end
  end

  describe "load and search actions" do    

    before {
      FactoryGirl.create(:country)
      FactoryGirl.create(:country, name: 'Canada')
      FactoryGirl.create(:state)
      FactoryGirl.create(:state, name: 'Nevada')
      FactoryGirl.create(:state, name: 'Calgary', country_id: 2)

      add_n_company(9)
      add_n_company(1, test_company1_attributes,test_company1_address)
      add_n_company(1, test_company2_attributes,test_company2_address)
      add_n_company(7)
      add_n_company(1, test_company3_attributes,test_company2_address)
    }

    describe "load companies with Ajax" do

      it "should respond with 10 Companies" do
        xhr :get, :load,  page: 2
        assigns(:companies).should have(10).Company
      end

      it "should first Company pitch='1 Pitch', last Company pitch='10 Pitch" do
        xhr :get, :load,  page: 2
        assigns(:companies).first.company_profile.should eq('1 Pitch')
        assigns(:companies).last.company_profile.should eq('10 Pitch')
      end

      it "should respond with success" do
        xhr :get, :load,  page: 2
        response.should be_success
      end

      it "should respond 6 Companies with company_country 'United States'" do
        xhr :get, :load,  page: 2, by_country: 1, country_id: "United States"
        assigns(:companies).should have(6).Company
      end
    end

    describe "search companies with Ajax" do
      it "should respond 2 companies with looked_tags = 'java,haml'" do
        xhr :get, :search, search_by_tags_mode: "looked_tags", by_tags: "java,haml"
        assigns(:companies).should have(10).Company
      end

      it "should respond 2 companies with offer_tags = 'css' and company_country = 'Canada'" do
        xhr :get, :search, by_country: 2, country_id: "Canada", search_by_tags_mode: "offer_tags", by_tags: 'css'
        assigns(:companies).should have(2).Company
      end

      it "should respond 10 Companies with company_country 'United States'" do
        xhr :get, :search, by_country: 1, country_id: "United States"
        assigns(:companies).should have(10).Company
      end

      it "should respond 1 Company with state 'Calgary'" do
        xhr :get, :search, by_state: 3, search_by_tags_mode: "looked_tags", by_tags: "sass"
        assigns(:companies).should have(1).Company
      end

      it "should respond 2 Company with city 'Calgary'" do
        xhr :get, :search, by_city: "Calgary"
        assigns(:companies).should have(2).Company
      end

      it "should respond Companies with name 'company'" do
        xhr :get, :search, by_name: "company"
        assigns(:companies).should have(10).Company
      end
    end
  end
end
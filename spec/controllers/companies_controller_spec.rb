require 'spec_helper'

describe CompaniesController, js: true do

  include Companies
  include Microposts

  let!(:user) { FactoryGirl.create(:user) }
  before { 
    sign_in(user)
    update_current_user_company(user, test_company1_attributes)
  }

  describe "GET 'show'" do
    before { 
      add_n_microposts(8, user)
    }

    it "returns http success" do
      get 'show', id: user.company.id
      response.should be_success
    end

    it "returns 2 top_wanted_capabilities" do
      get 'show', id: user.company.id
      assigns(:top_wanted_capabilities).count.should eq(2)
    end

    it "returns 3 top_sertifications" do
      get 'show', id: user.company.id
      assigns(:top_certifications).count.should eq(3)
    end

    it "returns 8 microposts" do
      get 'show', id: user.company.id
      assigns(:microposts).count.should eq(8)
    end
  end

  describe "GET 'edit'" do

    it "returns http success" do
      get 'edit', id: user.company.id
      response.should be_success
    end

    it "redirect to edit template" do
      get 'edit', id: user.company.id
      expect(response).to render_template("edit")
    end
  end

end
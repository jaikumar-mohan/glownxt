require 'spec_helper'


describe MicropostsController, js: true do

  include Microposts
  include Companies

  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  let!(:micropost) { FactoryGirl.create(:micropost, user: user) }
  let!(:other_micropost) { FactoryGirl.create(:micropost, user: other_user) }
  before { 
    sign_in user 
    update_current_user_company(user, test_company1_attributes)
  }

  describe "creating a Micropost with Ajax" do
    it "should increment the Micropost count" do
      expect do
        xhr :post, :create, company_id: user.company.id, micropost: { content: "foobar" }
      end.to change(Micropost, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, company_id: user.company.id, micropost: { content: "foobar" }
      response.should be_success
    end

    it "respond should micropost not create" do
      xhr :post, :create, company_id: other_user.company.id, micropost: { content: "foobar" }
      assigns(:micropost).should be_nil
    end

    it "Send micropost_content = empty should micropost not create" do
      expect do
        xhr :post, :create, company_id: user.company.id, micropost: { content: "" }
      end.to_not change(Micropost, :count).by(1)
    end
  end

  describe "delete a Micropost with Ajax" do
    it "should decrement the Micropost count" do
      expect do
        xhr :delete, :destroy, company_id: user.company.id, id: micropost.id
      end.to change(Micropost, :count).by(-1)
    end

    it "should respond with not success" do
      expect do
        xhr :delete, :destroy, company_id: other_user.company.id, id: other_micropost.id
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should respond with success" do
      xhr :delete, :destroy, company_id: user.company.id, id: micropost.id
      response.should be_success
    end
  end

  describe "load companies with Ajax" do    
    before {
      add_n_microposts(1, user, "1 micropost")

      add_n_microposts(30, other_user, "1 micropost")

      add_n_microposts(8, user)

      add_n_microposts(1, user, "10 micropost")

      add_n_microposts(10, user)

    }

    it "should respond with 10 Microposts" do
      xhr :get, :load,  page: 2, company_id: user.company.id
      assigns(:microposts).should have(10).Micropost
    end

    it "should first Micropost content_text '10 micropost'" do
      xhr :get, :load,  page: 2, company_id: user.company.id
      assigns(:microposts).first.content.should eq('10 micropost')
      assigns(:microposts).last.content.should eq('1 micropost')
    end


    it "should other_user Dashboard page first and last Microposts content_text '1 micropost'" do
      xhr :get, :load,  page: 2, company_id: other_user.company.id
      assigns(:microposts).last.content.should eq('1 micropost')
      assigns(:microposts).first.content.should eq('1 micropost')
    end
  end
end
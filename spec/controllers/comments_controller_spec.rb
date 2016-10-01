require 'spec_helper'


describe CommentsController do
  include Companies

  let!(:user) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  let!(:micropost) { FactoryGirl.create(:micropost, user: user) }
  let!(:comment) { FactoryGirl.create(:micropost, parent_id: micropost.id, user: user) }
  let!(:other_comment) { FactoryGirl.create(:micropost, parent_id: micropost.id, user: other_user) }
  

  describe "creating a comment with Ajax", js: true do
  	before { 
      sign_in user
      update_current_user_company(user, test_company1_attributes)
    }

    it "should increment the Comment count" do
      expect do
        xhr :post, :create, micropost_id: micropost.id, micropost: { content: "foobar" }
      end.to change(Micropost, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, micropost_id: micropost.id, micropost: { content: "foobar" }
      response.should be_success
    end

     it "Send comment_content = empty should comment not create" do
      expect do
        xhr :post, :create, micropost_id: micropost.id, micropost: { content: "" }
      end.to_not change(Micropost, :count).by(1)
    end
  end

  describe "delete a comment with Ajax", js: true do
  	before { sign_in user }
    it "should decrement the Comment count" do
      expect do
        xhr :delete, :destroy, micropost_id: micropost.id, id: comment.id
      end.to change(Micropost, :count).by(-1)
    end

    it "should respond with not success" do
      expect do
        xhr :delete, :destroy, micropost_id: micropost.id, id: other_comment.id
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should respond with success" do
      xhr :delete, :destroy, micropost_id: micropost.id, id: comment.id
      response.should be_success
    end
  end

end
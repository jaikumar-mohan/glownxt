require 'spec_helper'

describe ContactsController do

  include Contacts

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      assigns(:contact).should_not be_nil
      response.should be_success
    end
  end

  describe "create contact" do
    it "should increment the Contact count" do
      expect do
      	get 'create', contact: valid_contact_params
      end.to change(Contact, :count).by(1)
    end

    describe "Send all empty contact params" do
      before {
        get 'create', contact: empty_contact_params
        @errors = assigns(:errors)
      }

      it "should respond Errors[:first_name] = First name is required" do
        @errors['first_name'].should eq('First name is required')
      end

      it "should respond Errors[:email] = Email is required" do
        @errors['email'].should eq('Email is required')
      end

      it "should respond Errors[:last_name] = Last name is required" do
        @errors['last_name'].should eq('Last name is required')
      end

      it "should respond Errors[:body] = Comments is required" do
        @errors['body'].should eq('Comments is required')
      end

      it "should respond Errors[:company] = Company is required" do
        @errors['company'].should eq('Company is required')
      end

      it "should respond Errors.count = 5" do
        @errors.count.should eq(5)
      end
    end

    describe "Send contact params with invalid email" do
      before {
        get 'create', contact: valid_contact_params(invalid_email)
        @errors = assigns(:errors)
      }

      it "should respond Errors[:email] = Email is invalid" do
        @errors['email'].should eq('Email is invalid')
      end

      it "should respond Errors.count = 1" do
        @errors.count.should eq(1)
      end
    end

    it "returns http success" do
      get 'create', contact: valid_contact_params
      response.should be_success
    end
  end
end

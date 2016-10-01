require 'spec_helper'

describe UsersController do

  describe "GET 'pitching'" do

    describe "when not signed in'" do
      it "returns http failure" do
        get 'pitching'
        response.should_not be_success
      end
    end

    describe "when signed in", js: true do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      it "returns http success" do
        get 'pitching'
        response.should be_success
      end
    end

  end

end

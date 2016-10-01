require 'spec_helper'

describe "Micropost pages", js: true do
  include Companies
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }

  before { 
    sign_in user
    update_current_user_company(user, test_company1_attributes) 
  }

  # THIS 'CREATION' BLOCK IS NOT ACTUAL FOR NOW.
  # WE WILL CORRECT THIS TEST CASE WHEN POST CREATION PROCESS WILL BE COMPLETED

  # describe "micropost creation" do
  #   before { visit user_path(user) }

  #   describe "with invalid information" do
  #     it "should not create a micropost" do
  #       expect { click_button "Post" }.not_to change(Micropost, :count)
  #     end

  #     describe "error messages" do
  #       before { click_button "Post" }
  #       it { should have_content('error') }
  #     end
  #   end

  #   describe "with valid information" do
  #     before { fill_in 'micropost_content', with: "Lorem ipsum" }
  #     it "should create a micropost" do
  #       expect { click_button "Post" }.to change(Micropost, :count).by(1)
  #     end
  #   end
  # end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    describe "as correct user" do
      before { visit user_path(user) }
      it "should delete a micropost" do
        should have_css('.js-comments-destroy-link') 
      end
    end
  end

end
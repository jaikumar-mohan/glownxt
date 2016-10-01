require 'spec_helper'

describe "Authentication" do
  include Companies

  subject { page }

  describe "signin page" do
    before { visit new_user_session_path }
    it { should have_title('Glowfori | Sign in') }
  end

  describe "signin" do
    before { visit new_user_session_path }

    describe "with invalid information", js: true do
      before { click_button "Sign In" }

      it { should have_title('Glowfori | Sign in') }
      it { should have_selector('.error-text', text: 'is required') }
    end

    describe "with valid information", js: true do
      let!(:user) { FactoryGirl.create(:user) }

      before { 
        sign_in user
        update_current_user_company(user, test_company1_attributes)
      }

      it {
        find(".js-navigation-toggle-account").click 
        should have_link('Edit Company Profile')
      }
      it { 
        find(".js-navigation-toggle-account").click
        should have_link('Log out', href: destroy_user_session_path) 
      }
      it { should_not have_link('Sign In', href: new_user_session_path) }

      describe "followed by signout" do
        before { 
          find(".js-navigation-toggle-account").click
          click_link "Log out" 
        }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let!(:user) { FactoryGirl.create(:user) }

      it { should_not have_link('Edit Company Profile', href: edit_company_path(user.company)) }
      it { should_not have_link('Sign out', href: destroy_user_session_path) }

      describe "when attempting to visit a protected page", js: true do

        before { 
          sign_in user
        }

        it "should render user's name and company name on page" do
          should have_content('What we do')
          should have_content(user.company.company_profile)
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user", js: true do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { 
        sign_in user
        update_current_user_company(user, test_company1_attributes) 
      }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title('Glowfori | Edit user') }
      end

    end

    describe "in the Relationships controller" do
      describe "submitting to the create action" do
        before { post relationships_path }
        specify { response.should redirect_to(new_user_session_path) }
      end

      describe "submitting to the destroy action" do
        before { delete relationship_path(1) }
        specify { response.should redirect_to(new_user_session_path) }
      end
    end

  end

  # describe "as non-admin user", js: true do
  #   let!(:user) { FactoryGirl.create(:user) }
  #   let!(:non_admin) { FactoryGirl.create(:user) }

  #   before { 
  #     sign_in non_admin
  #     update_current_user_company(user, test_company1_attributes) 
  #   }

  #   describe "submitting a DELETE request to the Users#destroy action" do
  #     before { delete user_path(user) }
  #     specify { response.should redirect_to(root_path) }
  #   end
  # end
end
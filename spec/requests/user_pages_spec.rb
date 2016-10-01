require 'spec_helper'

describe "User Pages" do
  include Companies

  subject { page }

  describe "index", js: true do

    let!(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      update_current_user_company(user, test_company1_attributes)
    end

    # it { 
    #   visit users_path
    #   should have_title('All users') 
    #   should have_selector('h3', text: 'All users') 
    #   should have_selector('span', text: user.handle) 
    # }

    # describe "pagination" do

    #   before { 30.times { FactoryGirl.create(:user) }}
    #   after { User.delete_all }

    #   it "should list each user" do
    #     visit users_path
    #     User.all.page(1).each do |user|
    #       should have_selector('li', text: user.full_name)
    #       should have_link(user.handle, href: user_path(user))
    #     end
    #     should have_css('.pagination') 
    #   end
    # end

    # describe "delete links" do
    #   it { should_not have_link('delete') }
    #   describe "as an admin user" do
    #     let(:admin) { FactoryGirl.create(:admin) }
    #     before do
    #       sign_in admin
    #       visit users_path
    #     end
    #     it { should have_link('delete', href: user_path(User.first)) }
    #     it "should be able to delete another user" do
    #       expect { click_link('delete') }.to change(User, :count).by(-1)
    #     end
    #     it { should_not have_link('delete', href: user_path(admin)) }
    #   end
    # end
  end

#   describe "signup page" do
#     before { visit signup_path }

#     it { should have_selector('title', text: full_title('Sign up')) }
#     it { should have_selector('.page-heading', text: 'Sign up') }

#   end

#   describe "profile page" do
#     let(:user) { FactoryGirl.create(:user) }
#     let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
#     let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
#     before { 
#       sign_in user
#       visit user_path(user) 
#     }
#     it { should have_selector('h1', text: user.full_name) }
#     it { should have_selector('title', text: user.full_name) }

#     describe "microposts" do
#       it { should have_content(m1.content) }
#       it { should have_content(m2.content) }
#       it { should have_content(user.microposts.count) }
#     end

#     describe "follow/unfollow buttons" do
#       let(:other_user) { FactoryGirl.create(:user) }
#       before { sign_in user }

#       describe "following a user" do
#         before { visit user_path(other_user) }
#         it "should increment the followed user count" do
#           expect do
#             click_button "Follow"
#           end.to change(user.followed_users, :count).by(1)
#         end
#         it "should increment the other user's followers count" do
#           expect do
#             click_button "Follow"
#           end.to change(other_user.followers, :count).by(1)
#         end

#         describe "toggling the button" do
#           before { click_button "Follow" }
#           it { should have_selector('input', value: 'Unfollow') }
#         end
#       end

#       describe "unfollowing a user" do
#         before do
#           user.follow!(other_user)
#           visit user_path(other_user)
#         end
#         it "should decrement the followed user count" do
#           expect do
#             click_button "Unfollow"
#           end.to change(user.followed_users, :count).by(-1)
#         end
#         it "should decrement the other user's followers count" do
#           expect do
#             click_button "Unfollow"
#           end.to change(other_user.followers, :count).by(-1)
#         end

#         describe "toggling the button" do
#           before { click_button "Unfollow" }
#           it { should have_selector('input', value: 'Follow') }
#         end
#       end
#     end
#   end

#   describe "signup" do
#     before { visit signup_path }
#     let(:submit) { "Submit" }

#     describe "with invalid information" do
#       it "should not create a user" do
#         expect { click_button submit }.not_to change(User, :count)
#       end
#     end

#     describe "after submission" do
#       before { click_button submit }
#       it { should have_selector('title', text: 'Sign up') }
#       it { should have_selector(".error-text") }
#     end

#     describe "with valid information" do
#       before do
#         fill_in "First Name", with: "Example"
#         fill_in "Last Name", with: "User"
#         #fill_in "Enter a nickname (max 20 characters)", with: "example"
#         fill_in "Password", with: "foobar"
#         fill_in "user[password_confirmation]", with: "foobar"
#         fill_in "Email", with: "user@example.com"
#         fill_in "Company Name", with: "Wayne Enterprises"
#         check 'user_tos'
#       end

#       it "should create a user" do
#         expect { click_button submit }.to change(User, :count).by(1)
#       end


#       describe "after saving the user" do
#         before { click_button submit }
#         let(:user) { User.find_by_email('user@example.com') }
#         it { page.should have_content('You will receive an email with validation steps in a few minutes.') }
# #        it { should have_link('Sign out') }
#       end
#     end
#   end

#   describe "edit" do
#     let(:user) { FactoryGirl.create(:user) }
#     before do
#       sign_in user
#       visit edit_company_path(user.company)
#     end

#     describe "page" do
#       it { should have_selector('h3', text: "User Settings") }
#       it { should have_selector('h3', text: "Company Settings") }
#       it { should have_selector('title', text: "Edit Company Profile") }
#       it { should have_link('change', href: 'http://gravatar.com/emails') }
#     end

#     describe "with invalid information" do
#       before { 
#         fill_in "First name", with: ""
#         fill_in "Last name", with: ""
#         fill_in "Email", with: ""
#         click_button "Save" 
#       }

#       it { page.should have_content("is required") }
#     end

#     describe "with valid information" do
#       let(:new_first_name) { "New" }
#       let(:new_last_name) { "NAME" }
#       #let(:new_nick) { "name" }
#       let(:new_email) { "new@example.com" }
#       before do
#         fill_in "First name", with: new_first_name
#         fill_in "Last name", with: new_last_name
#         fill_in "Password", with: user.password
#         fill_in "Password confirmation", with: user.password
#         fill_in "Email", with: new_email
#         click_button "Save"
#       end

#       it { should have_selector('div.alert.alert-success') }
#       it { should have_link('Sign out', href: signout_path) }
#       specify { user.reload.first_name.should == new_first_name }
#       specify { user.reload.last_name.should == new_last_name }
#       specify { user.reload.email.should == new_email }
#     end
#   end

#   describe "new/create pages for signed-in users" do
#     let(:user) { FactoryGirl.create(:user) }

#     before(:each) do
#       sign_in user
#       visit signup_path
#     end

#     it { should have_selector('title', text: user.full_name) }
#     it { should have_selector('div.alert.alert-info', text: "You're already logged in") }
#   end

#   describe "following/followers" do
#     let(:user) { FactoryGirl.create(:user) }
#     let(:other_user) { FactoryGirl.create(:user) }
#     before { user.follow!(other_user) }

#     describe "followed users = following" do
#       before do
#         sign_in user
#         visit following_user_path(user)
#       end
#       it { should have_selector('title', text: full_title('Companies we found')) }
#       it { should have_selector('h3', text: 'Companies we found') }
#       it { should have_link(other_user.full_name, href: user_path(other_user)) }
#     end

#     describe "followers" do
#       before do
#         sign_in other_user
#         visit followers_user_path(other_user)
#       end
#       it { should have_selector('title', text: full_title('Companies that found us')) }
#       it { should have_selector('h3', text: 'Companies that found us') }
#       it { should have_link(user.full_name, href: user_path(user)) }
#     end
#   end
end

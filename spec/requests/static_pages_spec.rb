require 'spec_helper'
describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Sign up Now"
    page.should have_title(full_title('Sign up'))
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { '' }
    it_should_behave_like "all static pages"
    it { should_not have_title(full_title('Home')) }

    describe "for signed-in users", js: true do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, to: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, to: user, content: "Dolor sit amet")
        sign_in user
      end

      describe "it should show the user's name and company name" do
        it { page.should have_content(user.company.company_name) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:page_title) { 'Help' }
  end

  describe "About page" do
    before { visit about_path }
    let(:page_title) { 'About Us' }
  end
end

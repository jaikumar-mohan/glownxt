# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  to_id      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  let(:userToReplyTo) { FactoryGirl.create(:userToReplyTo) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:third_user) { FactoryGirl.create(:user) }

  let!(:user_post) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
  let!(:other_post) { FactoryGirl.create(:micropost, user: other_user, content: "bar") }
  let!(:third_post) { FactoryGirl.create(:micropost, user: third_user, content: "baz") }
  let!(:fourth_post) { FactoryGirl.create(:micropost, user: third_user, content: "@@#{userToReplyTo.email} hello") }
  let!(:fifth_post) { FactoryGirl.create(:micropost, user: user, content: "@@#{userToReplyTo.email} Look a reply to Donald") }

  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:to) }
  its(:user) { should == user }
  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end

  describe "replies" do
    it "should identify a user and set the in_reply_to field accordingly" do
      fifth_post.to.should == userToReplyTo
    end
  end

  describe "from users followed by replies" do

    before(:each) do
      user.follow!(other_user)
    end

    it "should have a from_users_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by_including_replies)
    end

    it "should include the followed user's microposts" do
      Micropost.from_users_followed_by_including_replies(user).should include(other_post)
    end

    it "should include the user's own microposts" do
      Micropost.from_users_followed_by_including_replies(user).should include(user_post)
    end

    it "should not include an unfollowed user's microposts" do
      Micropost.from_users_followed_by_including_replies(user).should_not include(third_post)
    end

    it "should include posts to user" do
      Micropost.from_users_followed_by_including_replies(userToReplyTo).should include(fourth_post)
    end

    it "should not include posts to other user" do
      Micropost.from_users_followed_by_including_replies(user).should_not include(fourth_post)
    end

  end

  describe "never see posts meant for another user" do

    before(:each) do
      third_user.follow!(user)
    end

    it "should not include posts to other user" do
      Micropost.from_users_followed_by_including_replies(third_user).should_not include(fifth_post)
    end
  end

end


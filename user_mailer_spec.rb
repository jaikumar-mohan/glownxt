require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) {
      user.password_reset_token = "xxxxx";
      UserMailer.password_reset user
    }

    it "renders the headers" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["info@glowfori.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("To reset your password, click the URL below.")
    end
  end

end

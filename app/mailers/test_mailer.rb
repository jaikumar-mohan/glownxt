class TestMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome(email)
    mail to: email, subject: "Test Mailer"
  end
end

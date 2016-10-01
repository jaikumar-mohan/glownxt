class ContactMailer < ActionMailer::Base
  def send_message(contact)
    @contact = contact
    mail(to: 'info@glowfori.com', from: contact.email, subject: "Contact Us")
  end
end

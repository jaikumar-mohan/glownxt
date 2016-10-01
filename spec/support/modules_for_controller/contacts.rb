module Contacts
  def valid_contact_params(email = nil)
  	email = "test@example.com" unless email
  	contact_params = {first_name: "Donald", last_name: "DUCK", 
      	email: email, company: "Test company", body: "Test Hello"}
  end

  def empty_contact_params
  	contact_params = {first_name: "", last_name: "", 
      	email: "", company: "", body: ""}
  end

  def invalid_email
  	"test@exampl"
  end
end
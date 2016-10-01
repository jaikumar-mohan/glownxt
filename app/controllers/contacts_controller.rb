require 'validations_on_views/contact'

class ContactsController < ApplicationController
  
  include ValidationsOnViews::Contact
  
  before_action :set_active_tab!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.ip = request.remote_ip
    unless has_wrong_ops?
      @contact.save
      ContactMailer.send_message(@contact).deliver
    end
  end

  private
  
  def contact_params
    params.require(:contact).permit(:body, :company, :email, :first_name, :last_name)
  end

  def set_active_tab!
    @active_tab = 'contact' 
  end
end

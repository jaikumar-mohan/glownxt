class Contact < ActiveRecord::Base
  #attr_accessible :body, :company, :email, :first_name, :last_name
  validates_presence_of :body, :first_name, :last_name, :email, :company
  validates_length_of :email, :first_name, :last_name, maximum: 255

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, with: VALID_EMAIL_REGEX

  def full_name
    "#{first_name} #{last_name}"
  end
end

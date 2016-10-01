class Address < ActiveRecord::Base
  #attr_accessible :city, :country, :state, :street, :tel, :zip

  belongs_to :company
  belongs_to :country, class_name: 'LocationCountry'
  belongs_to :state

  validates :company_id, presence: true
end

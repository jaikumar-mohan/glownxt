class State < ActiveRecord::Base

  belongs_to :country, class_name: 'LocationCountry'

  scope :by_name, -> (query) { where("lower(name) LIKE (?)", "#{query.downcase}%") }
end

class LocationCountry < ActiveRecord::Base

  self.table_name = 'countries'

  has_many :states, dependent: :destroy

  scope :by_name, -> (query) { where("lower(name) LIKE (?)", "#{query.downcase}%") }
end

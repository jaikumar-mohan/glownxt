require "#{Rails.root}/lib/taggable_extensions/company_relations.rb"
require "#{Rails.root}/lib/taggable_extensions/company_helpers.rb"

class Company < ActiveRecord::Base

  include TaggableExtensions::CompanyRelations
  include TaggableExtensions::CompanyHelpers
  
  POSSIBLE_SEARCH_OPS = %w{ name country state city }
  TAGS_DATA = {
    capabilities_offered: 'Capabilities you offer',
    capabilities_lookedfor: 'Capabilities you look for',
    company_certification: 'Certifications your company holds'
  }

  has_one :company_relationship
  has_one :user, through: :company_relationship

  has_many :addresses, dependent: :destroy

  has_many :glows
  has_many :messages

  accepts_nested_attributes_for :addresses

  scope :by_name, -> (name) { 
    where("lower(companies.company_name) LIKE ?", "%#{name.downcase}%")
  }

  scope :by_city, -> (city) {
    joins(:addresses).
    where("addresses.city LIKE ?", "%#{city}%")
  }

  scope :by_state, -> (state_id) {
    joins(:addresses).
    where("addresses.state_id = ?", state_id)
  }

  scope :by_country, -> (country_id) {
    joins(:addresses).
    where("addresses.country_id = ?", country_id)
  }  

  scope :by_offer_tags, -> (tags) { 
    tagged_with(tags.split(','), on: :capabilities_offered, any: true)
  }   

  scope :by_looked_tags, -> (tags) {
    tagged_with(tags.split(','), on: :capabilities_lookedfor, any: true)
  }

  scope :by_certificates, -> (tags) {
    tagged_with(tags.split(','), on: :company_certification, any: true)
  }  

  scope :not_in, -> (company) {
    where("companies.id NOT IN (?)", company.id)
  }

  scope :verified, -> {
    joins(:user).
    where("users.confirmed_at IS NOT NULL")
  }

  def addresses_attributes=(attributes)
    self.primary_address.update(attributes['0'])
  end

  def addresses_attributes=(attributes)
    self.primary_address.update_attributes(attributes['0'])
  end

  def primary_address
    addresses.first || addresses.build
  end

  has_attached_file :logo, styles: { large: '137x137#', medium: '100x60#', thumb: '50x50#' }, default_url: "missing.gif"
  validates_attachment :logo, size: { in: 1..2.megabytes }, content_type: { content_type: %r{^image/(?:png|jpe?g|gif)\b}i, message: 'not an image or empty file' }

  validates :company_name, presence: true, uniqueness: {case_sensitive: false}
  #validates :company_country, presence: true

  #VALID_DOMAIN = /[a-z\d\-.]+\.[a-z]+\z/i
  #validates :company_domain, format: {with: VALID_DOMAIN}, uniqueness: {case_sensitive: false}

  before_save { |company| company.company_domain = self.company_domain.downcase if self.company_domain }

  acts_as_taggable

  def self.tag_cloud_for(what, n = 30)
    tag_counts_on(what).order('count desc').limit(n).map {|x| [x.name, x.count]}
  end

  def top_capabilities(type)
    self.class.tag_counts_on(type).
      where("tags.name IN (?)", send(type + '_list')).
      order('count desc').
      map {|x| [x.name, x.count - 1]}
  end

  # capabilities, that your company offer
  def top_capabilities_wanted_right_now(glowing = nil)
    tags_offer = top_capabilities('capabilities_offered')
    if glowing == true
      tags_offer.select { |tag_block| tag_block[1] > 0 }
    elsif glowing == false
      tags_offer.select { |tag_block| tag_block[1] == 0 }
    end
  end

  # capabilities, that your company looking for
  def top_capabilities_needed_right_now(glowing = nil)
    tags_needed = top_capabilities('capabilities_lookedfor')
    if glowing == true
      tags_needed.select { |tag_block| tag_block[1] > 0 }
    elsif glowing == false
      tags_needed.select { |tag_block| tag_block[1] == 0 }
    end
  end 

  def companies_with_capailities(type)
    self.class.tag_counts_on(type).
      where("tags.name IN (?)", send(inverse_capability(type) + '_list')).
      order('count desc').
      map {|x| [x.name, x.count]}
  end

  def inverse_capability(type)
    type == 'capabilities_offered' ? 'capabilities_lookedfor' : 'capabilities_offered'
  end

  class << self
    def search(current_user, search_ops, tags_mode, tags_list)
      companies = Company.verified.not_in(current_user.company)

      search_ops.each do | k, v |
        companies = companies.send(k, v) if search_ops[k].present?
      end
      
      companies = companies.send("by_#{tags_mode}", tags_list) if tags_list.present?
      companies.includes(:addresses)
    end
  end
end

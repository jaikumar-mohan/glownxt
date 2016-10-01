# == Schema Information
#
# Table name: companyrelationships
#
#  id         :integer          not null, primary key
#  company_id :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CompanyRelationship < ActiveRecord::Base
  #attr_accessible :id, :company_id, :user_id
# \b.todo company_id and user_id shall not be accessible in PROD, need a solution here to remove these in prod

  belongs_to :company
  belongs_to :user

  validates_presence_of :user, :company
  validates_uniqueness_of :user_id

end

# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  company_name    :string(255)
#  company_country :string(255)
#  company_domain  :string(255)
#  company_profile :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Company do
  let(:user) { FactoryGirl.create(:user) }
  before { @company = Company.new(company_name: "Glowfori", company_country: "Switzerland", company_domain: "glowfori.com")}

  subject { @company }
  it { should respond_to(:company_name) }
  it { should respond_to(:company_country) }
  it { should respond_to(:company_domain) }
  it { should be_true }

  describe "creating companyrelationship" do
    before { @companyrelationship = @company.build_company_relationship(user_id: "1") }
    it { should be_true }
  end

  describe "when companies name is not present" do
    before { @company.company_name = " " }
    it { should_not be_valid }
  end

  describe "when companies country is not present" do
    before { @company.company_country = " " }
    it { @company.should be_valid }
  end

  describe "when companies domain is not present" do
    before { @company.company_domain = " " }
    it { @company.should be_valid }
  end

  describe "when domain is already taken" do
    before do
      company_with_same_domain = @company.dup
      company_with_same_domain.company_domain = @company.company_domain.upcase
      company_with_same_domain.save
    end
    it { should_not be_valid }
  end

  describe "find a companies by name" do
    before { @company.save }
    let(:found_company) { Company.find_all_by_company_name(@company.company_name) }

  end
end
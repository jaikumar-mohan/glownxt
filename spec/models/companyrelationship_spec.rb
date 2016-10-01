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

require 'spec_helper'

describe CompanyRelationship do
  let(:user) { FactoryGirl.create(:user) }
  before { @companyrelationship = user.company_relationship }

  subject { @companyrelationship }
  it { should respond_to(:company_id) }
  it { should respond_to(:user_id) }
  its(:user) { should == user }
  it { should be_true }


  describe "when company_id is not present" do
    before { @companyrelationship.company_id = " " }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @companyrelationship.user_id = " " }
    it { should_not be_valid }
  end

  describe "when user_id is already taken" do
    before do
      user_with_same_id = @companyrelationship.dup
      user_with_same_id.save
    end
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      pending("*** DISABLE FOR TESTS PURPOSE (I think) ***")
      expect do
        CompanyRelationship.new(user_id: user.id, company_id: company.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "find a companies by id" do
    before { @companyrelationship.save }
    let(:found_companyrelationship) { company_relationship.find_all_by_company_id(company_relationship.company_id) }
  end


end

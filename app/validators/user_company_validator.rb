class UserCompanyValidator < ActiveModel::Validator
  def validate(record)
    new_company = Company.new(company_name: record.company_name)

    if new_company.valid?
      record.company = new_company
    else
      record.errors[:company_name] << new_company.errors.messages[:company_name].first
    end
  end
end
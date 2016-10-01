class TaggableCustomValidator < ActiveModel::Validator

  def validate(record)
    condition = record.certificate? ? 'certificates' : 'not_certificates'

    if ActsAsTaggableOn::Tag.send(condition).where(name: record.name).present?
      record.errors[:name] = 'should be unique!'
    end
  end

end
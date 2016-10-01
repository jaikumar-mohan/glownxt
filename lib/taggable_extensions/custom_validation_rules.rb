module TaggableExtensions::CustomValidationRules

  def self.included(base)
    base.class_eval do
      _validators.reject!{ |key, _| key == 'name' }

      _validate_callbacks.reject! do |callback|
        callback.raw_filter.attributes == ['name']
      end
    end
  end
end

module TaggableExtensions::CommonValidations
  extend ActiveModel::Validations
  extend ActiveSupport::Concern

  included do
    validates_with TaggableCustomValidator, on: :create
  end
end
Dir["#{Rails.root}/lib/taggable_extensions/*.rb"].each { |file| require file }

ActsAsTaggableOn::Tag.send(:include, TaggableExtensions::TagScopes)
ActsAsTaggableOn::Tag.send(:extend, TaggableExtensions::CustomValidationRules)
ActsAsTaggableOn::Tag.send(:include, TaggableExtensions::CommonValidations)
ActsAsTaggableOn::Tag.send(:extend, TaggableExtensions::Autocomplete)

ActsAsTaggableOn::Tagging.send(:include, TaggableExtensions::TaggingCallbacks)
ActsAsTaggableOn::Tagging.send(:include, TaggableExtensions::TaggingScopes)
ActsAsTaggableOn::Tagging.send(:include, TaggableExtensions::TaggingRelations)
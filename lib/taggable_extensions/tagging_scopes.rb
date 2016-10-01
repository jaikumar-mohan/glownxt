module TaggableExtensions::TaggingScopes

  def self.included(base)
    %w{ capabilities_offered capabilities_lookedfor company_certification }.each do | context_type |
      base.scope :with_context, -> ( context_type) {
        base.where("taggings.context = ?", context_type)
      }
    end
  end
  
end
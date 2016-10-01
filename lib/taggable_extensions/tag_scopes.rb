module TaggableExtensions::TagScopes

  def self.included(base)
    base.scope :certificates, -> {
      base.where(certificate: true)
    }

    base.scope :not_certificates, -> {
      base.where(certificate: false)
    }
  end
  
end
module TaggableExtensions::TaggingRelations

  def self.included(base)
    base.class_eval do
      belongs_to :company, -> { where("taggings.taggable_type = ?", 'Company') }, foreign_key: 'taggable_id'
    end
  end

end
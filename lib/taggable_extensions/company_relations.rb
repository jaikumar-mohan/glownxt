module TaggableExtensions::CompanyRelations

  def self.included(base)
    base.class_eval do
      %w{ capabilities_offered capabilities_lookedfor company_certification }.each do | tags_type |

        has_many "#{tags_type}_taggings".to_sym, -> { where(context: tags_type) },
          source: :tagging,
          class_name: 'ActsAsTaggableOn::Tagging',
          foreign_key: :taggable_id,
          as: :taggable

        has_many tags_type.to_sym,
          through: "#{tags_type}_taggings".to_sym,
          source: :tag,
          class_name: 'ActsAsTaggableOn::Tag'

      end
    end
  end

end
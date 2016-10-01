module TaggableExtensions::CompanyHelpers

  %w{ capabilities_offered capabilities_lookedfor company_certification }.each do | tags_type |

    define_method("#{tags_type}_list=") do | tag_names |

      condition = tags_type == 'company_certification' ? 'certificates' : 'not_certificates'

      tags = tag_names.split(',').map do |n|
        ActsAsTaggableOn::Tag.send(condition).where(name: n.strip).first_or_create!
      end

      ids = self.send("#{tags_type}_ids")
      destroy_ids = ids - tags.map(&:id)

      tags.each do |tag|
        unless ids.include?(tag.id)
          self.send("#{tags_type}") << tag
        end
      end

      self.send("#{tags_type}_taggings").where("taggings.tag_id IN (?)", destroy_ids).destroy_all

    end

    define_method("#{tags_type}_list") do
      send( tags_type ).pluck(:name)
    end

  end

  def companies_with_capabilities(type)
    ActsAsTaggableOn::Tagging.
      with_context(type).
      joins(:tag).
      where('tags.name IN (?) AND taggings.taggable_id != ?', send(inverse_capability(type) + '_list'), id).
      group("taggings.taggable_id").
      count.size
  end

  def companies_with_capabilities_in_same_city(type)
    ActsAsTaggableOn::Tagging.
      with_context(type).
      joins(:tag, company: [ :addresses ]).
      where('tags.name IN (?) AND addresses.state_id = ? AND lower(addresses.city) = ? AND taggings.taggable_id != ?', 
        send(inverse_capability(type) + '_list'), primary_address.state_id, primary_address.city.to_s.downcase, id).
      group("taggings.taggable_id").
      count.size
  end

  def most_popular_capability(type)
    self.class.tag_counts_on(type).
      where('tags.name IN (?)', send(inverse_capability(type) + '_list')).
      order('count desc').first.try(:name)
  end
end
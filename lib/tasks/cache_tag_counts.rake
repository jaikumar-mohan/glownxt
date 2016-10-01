namespace :db do
  desc "Fill database with sample data"
  task cache_tag_counts: :environment do
    cache_tag_counts!
  end
end

def cache_tag_counts!
  ActsAsTaggableOn::Tag.all.each do |tag| 
    offered_taggings_count = tag.taggings.with_context('capabilities_offered').count
    tag.update_column(:offered_taggings_count, offered_taggings_count)

    lookedfor_taggings_count = tag.taggings.with_context('capabilities_lookedfor').count
    tag.update_column(:lookedfor_taggings_count, lookedfor_taggings_count)

    company_certification = tag.taggings.with_context('company_certification')
    if company_certification.present?  
      tag.update_column(:certificate, true)
      tag.update_column(:certifications_count, company_certification.count)
    end
  end
end
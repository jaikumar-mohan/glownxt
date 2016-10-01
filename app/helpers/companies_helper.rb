module CompaniesHelper

  def tags_list(company, search_by_tags_mode)
    method_name = case search_by_tags_mode.to_s
      when 'looked_tags'
        'capabilities_lookedfor'
      when 'certificates'
        'company_certification'
      else
        'capabilities_offered'
    end

    company.send("#{method_name}_list").join(', ')
  end

end

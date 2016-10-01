module TaggableExtensions::Autocomplete

  def autocomplete(q, certificates)
    send(certificates ? 'certificates' : 'not_certificates').
      where("lower(tags.name) LIKE ?", "#{q.downcase}%").
      order('name ASC').limit(5)
  end
  
  def autocomplete_data(q, certificates)
    autocomplete(q, certificates).map(&:name)
  end

end
module CompanyModules::Search

  private

  def search_by_conditions
    mode, tags_list = params[:search_by_tags_mode], params[:by_tags]
    search_ops = params.select do |k, v| 
      "by_#{k}" if Company::POSSIBLE_SEARCH_OPS.include?(k.gsub('by_', ''))
    end
    @companies = Company.search(current_user, search_ops, mode, tags_list).
      page(params[:page]).per(10) 
  end  
end
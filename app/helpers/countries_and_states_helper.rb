module CountriesAndStatesHelper
  def country_titles_and_phone_codes
    ISO3166::Country::Data.map do |name, data|
      [ data['country_code'], data['name'].downcase ]
    end
  end

  def get_phone_prefix_by_country(country_name)
    results = country_titles_and_phone_codes.
      select { |c| c[1] == country_name.downcase }[0]

    results.present? ? results[0] : ''
  end
end
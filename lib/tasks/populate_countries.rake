namespace :db do  
  task populate_countries: :environment do
    data = YAML.load_file("#{Rails.root}/lib/tasks/data/countries.yaml")

    data.each do |k, v|
      country = Country.where(iso: k).first

      if country.present?
        puts "[ ADDED PHONE PREFIX #{v['country_code']} TO ] country with iso: #{k}, name: #{v['name']}"

        if country.phone_prefix.blank?
          country.update_column(:phone_prefix, v['country_code'])
        end

        check_states(country)
      else
        puts "[ NOT FOUND ] country with iso: #{k}"

        next_id = Country.last.try(:id).to_i + 1
        new_country = Country.create!(id: next_id, iso: k, name: v['name'], phone_prefix: v['country_code'])

        puts "[ COUNTRY #{new_country.name} ( #{new_country.iso} ) ] added!"

        check_states(new_country)
      end
    end
  end
end

def check_states(country)
  states_file_path = "#{Rails.root}/lib/tasks/data/subdivisions/#{country.iso}.yaml"

  if File.exist?(states_file_path)
    data = YAML.load_file(states_file_path)

    data.each do |k, v|
      state = State.where(iso: k, country_id: country.id).first

      if state.present?
        puts "[ COUNTRY #{country.iso} ] state #{k} already exist!"
      else
        next_id = State.last.try(:id).to_i + 1
        State.create!(id: next_id, iso: k, name: v['name'], country_id: country.id)
         
        puts "[ COUNTRY #{country.iso} ] state #{k} added!"
      end
    end
  end
end
namespace :db do
  desc "Drop all contacts"
  task contacts_drop: :environment do
    contacts_drop!
  end
end

def contacts_drop!
  Contact.destroy_all
end
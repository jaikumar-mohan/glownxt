namespace :db do
  desc "Convert users to devise"
  task convert_users_to_devise: :environment do
    convert_users_to_devise!
  end
end

def convert_users_to_devise!
  User.all.each do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.save!
    user.update_column(:confirmed_at, Time.now)
    user.update_column(:confirmation_sent_at, Time.now)
  end
end
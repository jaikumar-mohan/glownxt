if Rails.env.production? || Rails.env.development?
  Glowcon::Application.config.action_mailer.delivery_method = :smtp
  Glowcon::Application.config.action_mailer.smtp_settings = {
    address:               'smtp.gmail.com',
    port:                  587,
    domain:                'smtp.gmail.com',
    user_name:             'jbjegan12@gmail.com',
    password:              'jbjegan#212',
    authentication:        'plain',
    enable_starttls_auto:  true
  }
else
  Glowcon::Application.config.action_mailer.delivery_method = :sendmail
end

if Rails.env.production? || Rails.env.development?
  Glowcon::Application.config.action_mailer.delivery_method = :smtp
  Glowcon::Application.config.action_mailer.smtp_settings = {
    address:               'smtpout.europe.secureserver.net',
    port:                  80,
    domain:                'glowfori.com',
    user_name:             'account-creation-development@glowfori.com',
    password:              'dev2013',
    authentication:        'plain',
    enable_starttls_auto:  true
  }
else
  Glowcon::Application.config.action_mailer.delivery_method = :sendmail
end
if Rails.env.production? || Rails.env.development?
  Glowcon::Application.config.action_mailer.delivery_method = :smtp
  Glowcon::Application.config.action_mailer.smtp_settings = {
    address:               'smt.gmail.com',
    port:                  587,
    domain:                'smtp.gmail.com',
    user_name:             'chatwithjai@gmail.com',
    password:              'gmailjai',
    authentication:        'plain',
    enable_starttls_auto:  true
  }
else
  Glowcon::Application.config.action_mailer.delivery_method = :sendmail
end

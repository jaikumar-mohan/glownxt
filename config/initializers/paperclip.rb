if Rails.env.development? || Rails.env.test?
  Paperclip::Attachment.default_options[:storage] = :filesystem
else
  S3_CONFIGS = YAML.load_file("#{Rails.root}/config/settings_in_yaml/s3.yml")[Rails.env]['s3']

  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    bucket: S3_CONFIGS['bucket'],
    access_key_id: S3_CONFIGS['aws_access_key_id'],
    secret_access_key: S3_CONFIGS['aws_secret_access_key']
  }
end
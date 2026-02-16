ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'hidesys-service.sakura.ne.jp',
  domain: 'mail.mantropy.com',
  port: 587,
  user_name: 'no-replay@mail.mantropy.com',
  password: ENV.fetch('SMTP_PASSWORD', nil),
  authentication: 'plain',
  enable_starttls_auto: true
}

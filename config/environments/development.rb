Mantropy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # StrongParametersに失敗したらRaise
  config.action_controller.action_on_unpermitted_parameters = :raise

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # config.action_mailer.default_url_options = { :host => "192.168.74.19", :port => 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'hidesys-service.sakura.ne.jp',
    domain: 'mail.mantropy.com',
    port: 587,
    user_name: 'no-replay@mail.mantropy.com',
    password: ENV.fetch('SMTP_PASSWORD', nil),
    authentication: 'plain',
    enable_starttls_auto: true
  }

  config.assets.digest = false
  config.eager_load = false
  config.hosts.clear
end

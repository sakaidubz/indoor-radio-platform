Rails.application.configure do
  # Code is reloaded any time it changes.
  config.eager_load = false
  config.consider_all_requests_local = true

  # Log level
  config.log_level = :debug

  # Don't care if the mailer can't send in dev
  config.action_mailer.raise_delivery_errors = false if config.respond_to?(:action_mailer)
end


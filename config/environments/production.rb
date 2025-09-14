Rails.application.configure do
  # Eager load code on boot for better performance in production.
  config.eager_load = true
  config.consider_all_requests_local = false

  # Log at info level in production
  config.log_level = :info
end


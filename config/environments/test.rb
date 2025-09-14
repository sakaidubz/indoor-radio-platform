Rails.application.configure do
  # Cache classes for faster test runs; don't eager load by default.
  config.eager_load = false
  config.consider_all_requests_local = true

  # Use the lowest log level to avoid log noise in CI
  config.log_level = :warn
end


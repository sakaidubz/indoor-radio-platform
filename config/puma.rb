# Puma configuration

port ENV.fetch("PORT", 3000)
environment ENV.fetch("RAILS_ENV", "development")
workers ENV.fetch("WEB_CONCURRENCY", 0)
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
threads threads_count, threads_count

preload_app!


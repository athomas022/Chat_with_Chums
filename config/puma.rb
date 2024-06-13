# Set the number of threads per worker
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Set the number of workers
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
end

# Set worker timeout for development
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specify the port Puma will listen on to receive requests, default is 3000
port ENV.fetch("PORT") { 3000 }

# Set the environment in which Puma will run
environment ENV.fetch("RAILS_ENV") { "development" }

# Specify the pidfile location
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow puma to be restarted by `rails restart` command
plugin :tmp_restart
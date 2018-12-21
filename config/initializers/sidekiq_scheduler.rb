require 'sidekiq/scheduler'

# puts "Sidekiq.server? is #{Sidekiq.server?.inspect}"
# puts "defined?(Rails::Server) is #{defined?(Rails::Server).inspect}"
# puts "defined?(Unicorn) is #{defined?(Unicorn).inspect}"

if Rails.env == 'production' && (defined?(Rails::Server) || defined?(Unicorn))
  Sidekiq.configure_server do |config|

    config.on(:startup) do
      Sidekiq.schedule = YAML
        .load_file(File.expand_path('../../../current/config/scheduler.yml', __FILE__))
      Sidekiq::Scheduler.reload_schedule!
    end
  end
else
  Sidekiq::Scheduler.enabled = false
  puts "Sidekiq::Scheduler.enabled is #{Sidekiq::Scheduler.enabled.inspect}"
end

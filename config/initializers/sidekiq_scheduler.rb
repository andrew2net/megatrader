require 'sidekiq/scheduler'

puts "Sidekiq.server? is #{Sidekiq.server?.inspect}"
puts "defined?(Rails::Server) is #{defined?(Rails::Server).inspect}"
puts "defined?(Unicorn) is #{defined?(Unicorn).inspect}"

# if Rails.env == 'production' && (defined?(Rails::Server) || defined?(Unicorn))
  Sidekiq.configure_server do |config|

    config.on(:startup) do
      Sidekiq.schedule = YAML
        .load_file(File.expand_path('../../../config/scheduler.yml', __FILE__))
      Sidekiq::Scheduler.reload_schedule!
    end
  end
# else
  # Sidekiq::Scheduler.enabled = false
  # puts "Sidekiq::Scheduler.enabled is #{Sidekiq::Scheduler.enabled.inspect}"
# end
# Sidekiq.configure_server do |config|
    # config.periodic do |mgr|
    #       # see any crontab reference for the first argument
    #       # e.g. http://www.adminschoice.com/crontab-quick-reference
    #   mgr.register('* * * * *', Admin::GetCorrelationWorker)
    #   #         mgr.register('0 * * * *', SomeHourlyWorkerClass)
    #   #             mgr.register('* * * * *', SomeWorkerClass, retry: 2, queue: 'foo')
    #   #                 mgr.register(cron_expression, worker_class, job_options={})
    #   #                   end
    #   #                   end
    # end
# end

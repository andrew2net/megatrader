Sidekiq.configure_server do |config|
    config.periodic do |mgr|
          # see any crontab reference for the first argument
          # e.g. http://www.adminschoice.com/crontab-quick-reference
      mgr.register('* * * * *', Admin::GetCorrelationWorker)
      #         mgr.register('0 * * * *', SomeHourlyWorkerClass)
      #             mgr.register('* * * * *', SomeWorkerClass, retry: 2, queue: 'foo')
      #                 mgr.register(cron_expression, worker_class, job_options={})
      #                   end
      #                   end
    end
end

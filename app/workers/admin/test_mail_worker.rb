class Admin::TestMailWorker
  include Sidekiq::Worker

  def perform(*args)
    params = {name: 'Megatrader', email: 'info@megatrader.org', subject: 'Test',
              question: 'Test message.'}
    UserMailer.question_email(params).deliver_now
  end
end

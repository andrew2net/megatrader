class ApplicationMailer < ActionMailer::Base
  default to: Setting.find_by(name: 'notify_email').value
  layout 'mailer'
end

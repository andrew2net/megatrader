class ApplicationMailer < ActionMailer::Base
  default from: proc { Setting.find_by(name: 'notify_email').value }
  layout 'mailer'

end

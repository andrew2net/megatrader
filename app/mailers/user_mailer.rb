class UserMailer < ApplicationMailer

  def question_email(name, email, question)
    @name = name
    @question = question
    email = %("#{name}" <#{email}>) unless name.empty?
    to = Setting.find_by(name: 'notify_email').value

    mail(from: email, to: to, subject: 'Вопрос с сайта mgatrader.org', delivery_method: :sendmail)
  end
end

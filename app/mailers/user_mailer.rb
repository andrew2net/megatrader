class UserMailer < ApplicationMailer

  def question_email(name, email, question)
    @name = name
    @question = question
    email = %("#{name}" <#{email}>) unless name.empty?

    mail(from: email, subject: 'Вопрос с сайта mgatrader.org', delivery_method: :sendmail)
  end
end

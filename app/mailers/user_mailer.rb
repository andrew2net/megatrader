class UserMailer < ApplicationMailer

  def question_email(data)
    @name = data[:name]
    @question = data[:question]
    @phone = data[:phone] if data.has_key? :phone
    @subject = data[:subject] if data.has_key? :subject
    email = %("#{@name}" <#{data[:email]}>) unless @name.blank?
    to = Setting.find_by(name: 'notify_email').value

    mail(from: email, to: to, subject: 'Вопрос с сайта mgatrader.org')
  end

  def download_email(user)
    @user = user
    I18n.locale = @user.locale
    mail(to: @user.email, subject: t(:demoversions))
  end
end

# encoding: utf-8
class UserMailer < ApplicationMailer

  def question_email(data)
    @name = data[:name]
    @question = data[:question]
    @phone = data[:phone] if data.has_key? :phone
    @subject = data[:subject] if data.has_key? :subject
    unless data[:name].blank?
      @email_name = %("#{@name}" <#{data[:email]}>)
    else
      @email_name = data[:email]
    end
    @email = data[:email]
    to = Setting.find_by(name: 'notify_email').value

    mail(to: to, subject: 'Вопрос с сайта mgatrader.org')
  end

  def download_email(user)
    @user = user
    I18n.locale = @user.locale
    mail(to: @user.email, subject: t(:demoversions))
  end

  def webinar_reg_email(user_webinar)
    @user_webinar = user_webinar
    I18n.locale = @user_webinar.user.locale
    mail to: @user_webinar.user.email, subject: t(:webinar_registration)
  end
end

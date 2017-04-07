# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def question_email
    UserMailer.question_email({
      name: 'Test name',
      question: 'Test quest',
      email: 'test@mail.com',
      phone: '223322',
      subject: 'Test subject'
    })
  end

  def download_email
    UserMailer.download_email User.first
  end

  def webinar_reg_email
    UserMailer.webinar_reg_email UserWebinar.first
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def download_email
    UserMailer.download_email User.first
  end

  def webinar_reg_email
    UserMailer.webinar_reg_email UserWebinar.first
  end
end

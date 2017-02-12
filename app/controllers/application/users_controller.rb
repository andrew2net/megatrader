class Application::UsersController < ApplicationController
  def email
    user = User.find_or_initialize_by email: params[:email]
    user.locale = params[:locale]
    user.save
    UserMailer.download_email(user).deliver_later
    head :ok
  end
end

class Application::QuestionController < ApplicationController
  skip_before_action :authenticate

  def new
  end

  def send_message
    @errors = {email: {}, question: {}}
    valid = true

    unless EmailValidator.valid? params[:email]
      @errors[:email] = {class: :input_error, data: {content: I18n.t(:email_invalid), trigger: :focus}}
      valid = false
    end

    if params[:question].empty?
      @errors[:question] = {class: :input_error, data: {content: I18n.t(:question_emty), trigger: :focus}}
      valid = false
    end

    respond_to do |format|
      if valid
        begin
          UserMailer.question_email(params[:name], params[:email], params[:question]).deliver_later
          format.js { render 'message_sent' }
        rescue
          format.js { render 'send_message', locals: {err: true} }
        end
      else
        format.js { render 'send_message', locals: {err: false} }
      end
    end
  end
end

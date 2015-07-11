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

    partial = params.has_key?(:phone) ? 'application/main/contact_form' : 'form'
    err = false
    sent = false

    respond_to do |format|
      if valid
        data = nil
        begin
          UserMailer.question_email(params).deliver_later
          sent = true
          # format.js { render 'message_sent' }
        rescue => e
          err = true
          # format.js { render 'send_message', locals: {err: true, part: partial} }
        end
      else
        data = params
      end
        format.js { render 'send_message', locals: {err: err, part: partial, data: data, sent: sent} }
      # end
    end
  end
end

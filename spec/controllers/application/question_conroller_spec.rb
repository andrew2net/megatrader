require 'rails_helper'

RSpec.describe Application::QuestionController, type: :controller do
  describe 'Post message' do
    it 'shold save message and user' do
      post_params = {
        locale: :en,
        name: 'John',
        email: 'john@email.com',
        subject: 'test',
        phone: '223322',
        question: 'Does it work?',
        format: :js
      }
      post :send_message, post_params
      expect(response).to have_http_status :success
      user = User.find_by email: post_params[:email]
      expect(user.name).to eq post_params[:name]
      message = Message.find_by user: user
      expect(message.subject).to eq post_params[:subject]
    end
  end
end

require 'rails_helper'

RSpec.describe AdminSessionController, type: :controller do
  describe 'POST #create' do
    setup :activate_authlogic
    context 'when password is invalid'  do
      it 'render the page with error' do
        admin = create :admin
        post :create, admin_session: {email: admin.email, password: 'invalid', remeber_me: 0}, return_path: '/admin'
        expect(response).to render_template 'admin/login'
        expect(flash[:notice]).to match(/^Неверный емейл или пароль/)
      end
    end

    context 'when password is valid' do
      it 'set the user in the session and redirect him to required page' do
        admin = create :admin
        post :create, admin_session: {email: admin.email, password: admin.password, remember_me: 0}, return_path: '/admin'
        expect(response).to redirect_to '/admin'
        expect(controller.current_user).to eq admin
      end
    end
  end
end

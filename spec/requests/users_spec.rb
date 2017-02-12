require 'rails_helper'

RSpec.describe 'Users api', type: :request do
  describe 'POST /users/email' do
    it 'return http staus 200' do
      post '/en/users/email', email: 'test@test.net'
      expect(response).to have_http_status :ok
    end
  end
end

require 'rails_helper'

RSpec.describe Admin::LicensesController, type: :controller do
  setup :activate_authlogic

  describe "GET #index" do
    it "returns http success" do
      admin = create :admin
      AdminSession.create admin
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end

end

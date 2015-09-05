require 'rails_helper'

RSpec.describe Admin::MenuItemsController, type: :controller do
  setup :activate_authlogic
  describe "GET #index" do
    it "should return http success" do
      admin = create :admin
      AdminSession.create admin
      create :menu_item
      get :index
      expect(response).to have_http_status :success
    end
  end

  describe "GET #new" do
    it "should return http success" do
      admin = create :admin
      AdminSession.create admin
      get :new
      expect(response).to have_http_status :success
    end
  end

  describe "POST #create" do
    it 'should return http success' do
      admin = create :admin
      AdminSession.create admin
      page = create :home_page
      post :create, menu_item: {ru: {title: 'Главная'}, en: {title: 'Home page'}, type: 1, page_id: page.id, weight: 10}
      expect(response).to have_http_status :success
    end
  end

  describe 'GET #edit' do
    it "should return http success" do
      admin = create :admin
      AdminSession.create admin
      menu_item = create :menu_item
      get :edit, id: menu_item.id
      expect(response).to have_http_status :success
    end
  end

  describe 'PUT #update' do
    it "should redirect to index" do
      admin = create :admin
      AdminSession.create admin
      menu_item = create :menu_item
      put :update, id: menu_item.id, menu_item: {ru: {title: 'Главная'}, en: {title: ' Main page'}, type: 1, page_id: menu_item.page_id, weight: 20}
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to admin_menu_items_path
    end
  end

  describe 'DELETE #destroy' do
    it "should redirect to index" do
      admin = create :admin
      AdminSession.create admin
      menu_item = create :menu_item
      delete :destroy, id: menu_item.id
      expect(response).to have_http_status :redirect
      expect(response).to redirect_to admin_menu_items_path
    end
  end
end

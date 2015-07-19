require 'rails_helper'

RSpec.describe Application::MainController, type: :controller do

  describe 'GET #index' do
    it 'returns http redirect' do
      create :home_page
      get :index, url: ''
      expect(response).to have_http_status :redirect
    end

    it 'should returns http success' do
      create :home_page
      get :index, locale: :ru, url: ''
      expect(response).to have_http_status :success
      get :index, locale: :en, url: ''
      expect(response).to have_http_status :success
    end

    it 'should rise error 404 if page not found for en locale' do
      I18n.locale = :en
      get :index, locale: :en, url: ''
      expect(response).to have_http_status :not_found
      expect(response).to render_template 'not_found'
      expect(response.body).to eq ''
    end
  end

  describe 'GET #news' do
    it 'returns http redirect' do
      create :news_page, url: '29-novost-10'
      get :news, url: '29-novost-10'
      expect(response).to have_http_status :redirect
    end

    it 'returns http success' do
      create :news_page, url: '29-novost-10'
      get :news, locale: :ru, url: '29-novost-10'
      expect(response).to have_http_status :success
      get :news, locale: :en, url: '29-novost-10'
      expect(response).to have_http_status :success
    end
  end

  describe 'GET #articles' do
    it 'should returns http redirect' do
      create :article_page
      get :articles
      expect(response).to have_http_status :redirect
    end

    it 'should returns http success' do
      create :article_page
      get :articles, locale: :en
      expect(response).to have_http_status :success
      get :articles, locale: :ru
      expect(response).to have_http_status :success
    end
  end

  describe 'GET #article' do
    it 'should returns http redirect' do
      create :article_page, url: '5-torgovlja-spredom'
      get :article, url: '5-torgovlja-spredom'
      expect(response).to have_http_status :redirect
    end

    it 'should returns http success' do
      create :article_page, url: '5-torgovlja-spredom'
      get :article, locale: :en, url: '5-torgovlja-spredom'
      expect(response).to have_http_status :success
      get :article, locale: :ru, url: '5-torgovlja-spredom'
      expect(response).to have_http_status :success
    end
  end
end

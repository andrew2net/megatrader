require 'rails_helper'

RSpec.describe "PagesDisplays", type: :request do
  describe "GET /" do
    it "should display home page" do
      create :home_page
      get root_path(locale: :en)
      expect(response).to render_template :index
      expect(response.body).to include 'Home page text'
      get root_path(locale: :ru)
      expect(response).to render_template :index
      expect(response.body).to include 'Home page text'
    end

    it "should display not found page" do
      get root_path(locale: :en)
      expect(response).to render_template :not_found
      expect(response.body).to include I18n.t :title, scope: :not_found
      get root_path(locale: :ru)
      expect(response).to render_template :not_found
      expect(response.body).to include I18n.t :title, scope: :not_found
    end
  end

  describe 'GET article' do
    it "should display article page" do
      create :article_page
      get article_en_path(locale: :en, url: '5-torgovlja-spredom')
      expect(response).to render_template :article
      expect(response.body).to include 'Article about issue'
      get article_en_path(locale: :ru, url: '5-torgovlja-spredom')
      expect(response).to render_template :article
      expect(response.body).to include 'Article about issue'
    end

    it "should display not found page" do
      get article_en_path(locale: :en, url: '5-torgovlja-spredom')
      expect(response).to render_template :not_found
      expect(response.body).to include I18n.t :title, scope: :not_found
      get article_en_path(locale: :ru, url: '5-torgovlja-spredom')
      expect(response).to render_template :not_found
      expect(response.body).to include I18n.t :title, scope: :not_found
    end
  end

  describe 'GET news' do
    it "should display news page" do
      create :news_page
      get news_en_path(locale: :en, url: '29-novost-10')
      expect(response).to render_template :article
      expect(response.body).to include 'New news'
    end

    it "should display not found page" do
      get news_en_path(locale: :en, url: '29-novost-10')
      expect(response).to render_template :not_found
    end
  end
end

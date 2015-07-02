class Application::MainController < ApplicationController
  skip_before_action :authenticate

  def index
    @page = Page.find_by url: request.env['PATH_INFO'].sub(/^\//, '')
    @news = Page.news.page(params[:page]).per(6)
    @text = @page.text.sub(/\[news_block\]/, render_to_string('application/news/block', layout: false))
    @text.sub!(/\[question_block\]/, render_to_string('application/question/new', layout: false))
    @text.sub!(/\[how_to_pay_block\]/, render_to_string('application/question/pay', layout: false))
    @text.sub!(/\[tester_block\]/, render_to_string('tester_block', layout: false))
    @text.sub!(/\[popup_video\]/, render_to_string('popup_video', layout: false))
    @text.sub!(/\[contact_form\]/, render_to_string('contact_form', layout: false))

    @locale_sw = locale_sw(
        {
            ru: {method: :page_path, params: {url: Globalize.with_locale(:ru) { @page.url }}},
            en: {method: :page_path, params: {url: Globalize.with_locale(:en) { @page.url }}}
        })
  end

  def news
    @locale_sw = locale_sw MenuItem::URLS[:news]
  end

  def articles
    @articles = Page.articles.page(params[:page]).per(3)
    @locale_sw = locale_sw MenuItem::URLS[:articles]
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def locale_sw(urls_data)
    case I18n.locale
      when :ru
        urls_data[:en][:params].merge! locale: :en
        urls_data[:en]
      when :en
        urls_data[:ru][:params].merge! locale: :ru
        urls_data[:ru]
    end
  end
end

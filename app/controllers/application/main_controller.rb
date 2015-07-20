class Application::MainController < ApplicationController
  skip_before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    case params[:action]
      when 'index'
        method_ru = method_en = :page_path
      when 'article'
        method_ru = :article_ru_path
        method_en = :article_en_path
      when 'news'
        method_en = :news_en_path
        method_ru = :news_ru_path
      else
        method_en = method_ru = :root_path
    end
    @locale_sw = locale_sw({ru: {method: method_ru, params: {url: params[:url] || ''}}, en: {method: method_en, params: {url: params[:url] || ''}}})
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')

    respond_to do |format|
      format.html {render 'not_found', status: :not_found}
      format.js {render :index}
    end
  end

  def index
    @page = Page.find_by!(url: params[:url] || '')
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')
    @errors = {email: {}, question: {}}
    @text = @page.text.sub(/\[news_block\]/, @news_html)
    @text.sub!(/\[question_block\]/, render_to_string(partial: 'application/question/new', locals: {data: nil}))
    @text.sub!(/\[how_to_pay_block\]/, render_to_string(partial: 'application/question/pay'))
    @text.sub!(/\[tester_block\]/, render_to_string(partial: 'tester_block'))
    @text.sub!(/\[popup_video\]/, render_to_string(partial: 'popup_video'))
    @text.sub!(/\[contact_form\]/, render_to_string(partial: 'contact_form', locals: {data: nil}))

    @locale_sw = locale_sw(
        {
            ru: {method: :page_path, params: {url: Globalize.with_locale(:ru) { @page.url }}},
            en: {method: :page_path, params: {url: Globalize.with_locale(:en) { @page.url }}}
        })
    respond_to do |format|
      format.html
      format.js
    end
  end

  def news
    @article = Page.find_by! url: params[:url]
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')
    @locale_sw = locale_sw MenuItem::URLS[:news]

    respond_to do |format|
      format.html { render :article }
      format.js { render :index }
    end
  end

  def articles
    @articles = Page.articles.page(params[:page]).per(3)
    @locale_sw = locale_sw MenuItem::URLS[:articles]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def article
    @article = Page.find_by! url: params[:url]
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')

    @locale_sw = locale_sw (
                               {
                                   ru: {method: :article_ru_path, params: {url: Globalize.with_locale(:ru) { @article.url }}},
                                   en: {method: :article_en_path, params: {url: Globalize.with_locale(:en) { @article.url }}}
                               })
    respond_to do |format|
      format.html
      format.js { render :index }
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

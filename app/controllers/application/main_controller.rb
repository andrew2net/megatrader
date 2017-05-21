class Application::MainController < ApplicationController
  skip_before_action :authenticate
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    request.format = :html unless [Mime::HTML, Mime::JS].include? request.format
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
    @locale_sw = locale_sw(
      {ru: {method: method_ru, params: {url: params[:url] || ''}},
       en: {method: method_en, params: {url: params[:url] || ''}}})
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block',
                                  formats: :html)
    respond_to do |format|
      format.html do
        render 'not_found', status: :not_found
      end

      format.js {render :index}
    end
  end

  def index
    url = params[:url].blank? ? '/' : params[:url]
    @page = Page.find_by!(url: url)
    @text = @page.text
    @errors = {email: {}, question: {}}
    news_rgxp = /\[news_block\]/
    if @text =~ news_rgxp
      @news = Page.news.page(params[:page]).per(5)
      @news_html = render_to_string(partial: 'application/news/block')
      @text.sub!(news_rgxp, @news_html)
    end

    replace_tag tag: 'question_block', view_path: 'application/question/new',
      locals: {data: nil}

    replace_tag tag: 'how_to_pay_block', view_path: 'application/question/pay'

    replace_tag tag: 'robokassa_block', view_path: 'robokassa_block'

    replace_tag tag: 'tester_block', view_path: 'tester_block'

    replace_tag tag: 'popup_video', view_path: 'popup_video'

    replace_tag tag: 'contact_form', view_path: 'contact_form', locals:{data:nil}

    replace_tag tag: 'correlation', view_path: 'correlation'

    replace_tag tag: 'spread', view_path: 'spread'

    replace_tag tag: 'pairs', view_path: 'pairs'

    replace_tag tag: 'download', view_path: 'download'

    if @page.url == '/'
      page_url_ru = page_url_en = ''
    else
      page_url_ru = Globalize.with_locale(:ru) { @page.url }
      page_url_en = Globalize.with_locale(:en) { @page.url }
    end
    @locale_sw = locale_sw(
        {
            ru: {method: :page_path,
                 params: {url: page_url_ru}},
            en: {method: :page_path,
                 params: {url: page_url_en}}
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
    logger.info "Locale: #{I18n.locale.to_s} #{I18n.locale.class}"
    @articles = Page.articles.with_translations(I18n.locale)
      .page(params[:page]).per(3)
    @locale_sw = locale_sw MenuItem::URLS[:articles]
    respond_to do |format|
      format.html
      format.js
    end
  end

  def article
    @article = Page.find_by! url: params[:url]
    @text = @article.text
    replace_tag tag: 'popup_video', view_path: 'popup_video'
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')

    @locale_sw = locale_sw ({
      ru: {method: :article_ru_path, params: {
        url: Globalize.with_locale(:ru) { @article.url }
      }},
      en: {method: :article_en_path, params: {
        url: Globalize.with_locale(:en) { @article.url }
      }}
    })
    respond_to do |format|
      format.html
      format.js { render :index }
    end
  end

  private
  def replace_tag(tag:, view_path:, locals: {})
    tag_rgxp = /\[#{tag}\]/
    @text.sub!(tag_rgxp, render_to_string(
      partial: view_path, locals: locals)) if @text =~ tag_rgxp
  end

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

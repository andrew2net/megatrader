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
    @locale_sw = locale_sw(
      {ru: {method: method_ru, params: {url: params[:url] || ''}},
       en: {method: method_en, params: {url: params[:url] || ''}}})
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')

    respond_to do |format|
      format.html {render 'not_found', status: :not_found}
      format.js {render :index}
    end
  end

  def index
    @page = Page.find_by!(url: params[:url] || '')
    @text = @page.text
    @errors = {email: {}, question: {}}
    news_rgxp = /\[news_block\]/
    if @text =~ news_rgxp
      @news = Page.news.page(params[:page]).per(5)
      @news_html = render_to_string(partial: 'application/news/block')
      @text.sub!(news_rgxp, @news_html)
    end

    question_rgxp = /\[question_block\]/
    @text.sub!(question_rgxp, render_to_string(
      partial: 'application/question/new', locals: {data: nil}
    )) if @text =~ question_rgxp

    how_to_pay_rgxp = /\[how_to_pay_block\]/
    @text.sub!(how_to_pay_rgxp, render_to_string(
      partial: 'application/question/pay')) if @text =~ how_to_pay_rgxp

    tester_block_rgxp = /\[tester_block\]/
    @text.sub!(tester_block_rgxp, render_to_string(
      partial: 'tester_block')) if @text =~ tester_block_rgxp

    popup_video_rgxp = /\[popup_video\]/
    @text.sub!(popup_video_rgxp, render_to_string(
      partial: 'popup_video')) if @text =~ popup_video_rgxp

    contact_form_rgxp = /\[contact_form\]/
    @text.sub!(contact_form_rgxp, render_to_string(
      partial: 'contact_form', locals: {data: nil})
              ) if @text =~ contact_form_rgxp

    correlation_rgxp = /\[correlation\]/
    @text.sub!(
      correlation_rgxp, render_to_string(partial: 'correlation')
    ) if @text =~ correlation_rgxp

    spread_rgxp = /\[spread\]/
    @text.sub!(spread_rgxp, render_to_string(partial: 'spread')
              )if @text =~ spread_rgxp

    pair_rgxp = /\[pairs\]/
    @text.sub!(pair_rgxp, render_to_string(partial: 'pairs')
              ) if @text =~ pair_rgxp

    @locale_sw = locale_sw(
        {
            ru: {method: :page_path,
                 params: {url: Globalize.with_locale(:ru) { @page.url }}},
            en: {method: :page_path,
                 params: {url: Globalize.with_locale(:en) { @page.url }}}
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
    @news = Page.news.page(params[:page]).per(5)
    @news_html = render_to_string(partial: 'application/news/block')

    @locale_sw = locale_sw ({
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

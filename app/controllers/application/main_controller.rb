class Application::MainController < ApplicationController
  skip_before_action :authenticate
  def index
    page = Page.find_by url: request.env['PATH_INFO'].sub(/^\//,'')
    @news = Page.news.page(params[:page]).per(6)
    @text = page.text.sub(/\[news_block\]/, render_to_string('application/news/block', layout: false))
    @text.sub!(/\[question_block\]/, render_to_string('application/question/new', layout: false))
  end
end

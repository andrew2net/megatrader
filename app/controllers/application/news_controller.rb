class Application::NewsController < ApplicationController
  def index
  end

  def page
  end

  def block
    @news = Page.news.page(params[:page]).per(4)
    render layout: false
  end
end

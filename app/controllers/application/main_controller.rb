class Application::MainController < ApplicationController
  skip_before_action :authenticate
  def index

  end
end
